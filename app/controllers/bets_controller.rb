# frozen_string_literal: true

class BetsController < ApplicationController
  def create
    currency = params[:bet][:bet_amount_currency]
    raise Money::Currency::UnknownCurrency if currency.empty?

    multiplier = random_multiplier
    bet_amount = params[:bet][:bet_amount].to_money(currency)
    win_amount = bet_amount * multiplier
    account = current_user.accounts.find_by(
      amount_currency: currency
    )

    win_params = {
      win_amount: win_amount,
      win_amount_currency: currency
    }

    account_params = {
      account: account
    }

    user_params = {
      user: current_user
    }

    complete_params = bet_params.merge(win_params).merge(account_params).merge(user_params)
    @bet = Bet.new(complete_params)

    Bet.transaction do
      if bet_amount.zero?
        @info = "Can't bet zero! Show me what you've got, playa'!"
      elsif !account
        @info = "You don't have a #{currency} account."
      elsif account.amount < bet_amount.to_money(currency)
        @info = "Insufficient funds. Mah' poor nigga'."
      elsif @bet.save
        @bet.account.update!(amount: @bet.account.amount - bet_amount + win_amount)
        @info = "You've made a bet of #{currency} #{bet_amount} and won #{currency} #{win_amount}!"
      else
        @info = "There's been an error. Woops..."
      end
    end
  rescue Money::Currency::UnknownCurrency
    @info = 'You have to choose a valid currency!'
  ensure
    flash.now[:alert] = @info
  end

  private

  def random_multiplier
    random_org_response = HTTParty.post(
      'https://api.random.org/json-rpc/1/invoke',
      body: {
        'jsonrpc' => '2.0',
        'method' => 'generateIntegers',
        'params' => {
          'apiKey' => ENV['RANDOM_ORG_API_KEY'],
          'n' => 1,
          'min' => 0,
          'max' => 2,
          'replacement' => true,
          'base' => 10
        },
        'id' => 24_780
      }.to_json
    )

    JSON(random_org_response.body)['result']['random']['data'][0]
  end

  def bet_params
    params.require(:bet).permit(:bet_amount, :bet_amount_currency)
  end
end
