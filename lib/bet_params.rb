# frozen_string_literal: true

module BetParams
  private

  def win_params(win_amount, currency, multiplier)
    {
      win_amount: win_amount,
      win_amount_currency: currency,
      multiplier: multiplier
    }
  end

  def account_params(account)
    {
      account: account
    }
  end

  def user_params
    {
      user: @current_user
    }
  end

  def win_eur_params(win_amount, currency)
    {
      win_amount_eur: bank.exchange(win_amount, currency, 'EUR'),
      win_amount_eur_currency: 'EUR'
    }
  end

  def complete_params(win_amount, currency, multiplier, account)
    {
      **win_params(win_amount, currency, multiplier),
      **account_params(account),
      **user_params,
      **win_eur_params(win_amount, currency)
    }
  end
end
