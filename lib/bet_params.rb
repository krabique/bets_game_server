# frozen_string_literal: true

module BetParams
  private

  def bet_base_params
    params.require(:bet).permit(:bet_amount, :bet_amount_currency)
  end

  def win_params
    {
      win_amount: @win_amount,
      win_amount_currency: @currency
    }
  end

  def account_params
    {
      account: @account
    }
  end

  def user_params
    {
      user: current_user
    }
  end

  def win_eur_params
    {
      win_amount_eur: bank.exchange(@win_amount, @currency, 'EUR'),
      win_amount_eur_currency: 'EUR'
    }
  end

  def complete_params
    bet_calculated_params = {
      **win_params, **account_params, **user_params, **win_eur_params
    }
    bet_base_params.merge(bet_calculated_params)
  end
end
