# frozen_string_literal: true

class BetsController < ApplicationController
  include MoneyHelpers
  include BetParams
  include MaximumBet

  def create
    process_bet
    set_info_flash

    @accounts = current_user.accounts
    @top_wins = Bet.order('win_amount_eur_cents DESC').limit(5).includes(:user)
  end

  private

  def set_info_flash
    if @info.is_a?(Array) && @info[0] == 'alert'
      flash.now[:alert] = @info[1]
    else
      flash.now[:notice] = @info
    end
  end

  def process_bet
    return unless calculate_bet

    @info = validate_bet_with_error_message
    save_bet unless @info
  end

  def save_bet
    Bet.transaction do
      commit_bet
    end
  rescue ActiveRecord::RecordInvalid
    @info = ['alert', "There's been an error. Woops..."]
  end

  # rubocop:disable Metrics/MethodLength
  #
  # Disabling MethodLength for the method as suggested in this discussion
  # https://github.com/bbatsov/rubocop/issues/494#issuecomment-339860349
  #
  # This is where all the validations go
  def validate_bet_with_error_message
    info =
      if !@account
        "You don't have a #{@currency} account."
      elsif @bet_amount.zero?
        "Can't bet zero! Show me what you've got, playa'!"
      elsif @account.amount < @bet_amount.to_money(@currency)
        "Insufficient funds. Mah' poor nigga'."
      elsif random_multiplier(500).zero?
        'You are banned! You cheater, you!'
      elsif maximum_bet_eur < bank.exchange(@bet_amount, @currency, 'EUR')
        "Your bet exceeds the maximum bet of #{@currency} " \
          "#{bank.exchange(@max_bet, 'EUR', @currency)} " \
          "(#{@max_bet.currency} #{@max_bet})"
      end

    info&.scan(/^.*$/)&.unshift('alert')
  end
  # rubocop:enable Metrics/MethodLength

  def commit_bet
    @bet.save!
    @bet.account.update!(amount: @bet.account.amount - @bet_amount +
      @win_amount)
    @info = "You've made a bet of #{@currency} #{@bet_amount} and won " \
      "#{@currency} #{@win_amount}!"
  end

  def calculate_bet
    @currency = params[:bet][:bet_amount_currency]
    raise Money::Currency::UnknownCurrency if @currency.empty?

    @multiplier = random_multiplier
    @bet_amount = params[:bet][:bet_amount].to_money(@currency)
    @win_amount = @bet_amount * @multiplier
    @account = current_user.accounts.find_by(amount_currency: @currency)

    @bet = Bet.new(complete_params)
  rescue Money::Currency::UnknownCurrency
    @info = ['alert', 'You have to choose a valid currency!']
    false
  end

  def random_multiplier(max_value = 2)
    random_org_response = HTTParty.post(
      'https://api.random.org/json-rpc/1/invoke',
      body: random_org_request_body(max_value)
    )

    JSON(random_org_response.body)['result']['random']['data'][0]
  end

  def random_org_request_body(max_value)
    {
      'jsonrpc' => '2.0',
      'method' => 'generateIntegers',
      'params' => random_org_request_body_params(max_value),
      'id' => 24_780
    }.to_json
  end

  def random_org_request_body_params(max_value)
    {
      'apiKey' => ENV['RANDOM_ORG_API_KEY'],
      'n' => 1,
      'min' => 0,
      'max' => max_value,
      'replacement' => true,
      'base' => 10
    }
  end
end
