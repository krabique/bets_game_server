# frozen_string_literal: true

class BetsController < ApplicationController
  include CommonHelpers

  def create
    calculate_bet
    process_bet
  rescue Money::Currency::UnknownCurrency
    @info = 'You have to choose a valid currency!'
  ensure
    flash.now[:alert] = @info
  end

  private

  def process_bet
    Bet.transaction do
      validate_bet
      unless @info
        if @bet.save
          update_account
        else
          @info = "There's been an error. Woops..."
        end
      end
    end
  end

  def validate_bet
    if !@account
      @info = "You don't have a #{@currency} account."
    elsif @bet_amount.zero?
      @info = "Can't bet zero! Show me what you've got, playa'!"
    elsif @account.amount < @bet_amount.to_money(@currency)
      @info = "Insufficient funds. Mah' poor nigga'."
    end
  end

  def update_account
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
    @account = current_user.accounts.find_by(
      amount_currency: @currency
    )

    @bet = Bet.new(complete_params)
  end

  def random_multiplier
    random_org_response = HTTParty.post(
      'https://api.random.org/json-rpc/1/invoke',
      body: random_org_request_body
    )

    JSON(random_org_response.body)['result']['random']['data'][0]
  end

  def random_org_request_body
    {
      'jsonrpc' => '2.0',
      'method' => 'generateIntegers',
      'params' => random_org_request_body_params,
      'id' => 24_780
    }.to_json
  end

  def random_org_request_body_params
    {
      'apiKey' => ENV['RANDOM_ORG_API_KEY'],
      'n' => 1,
      'min' => 0,
      'max' => 2,
      'replacement' => true,
      'base' => 10
    }
  end

  include BetParams
end
