# frozen_string_literal: true

FactoryBot.define do
  factory :bet do
    bet_amount                1
    bet_amount_currency       'EUR'

    factory :invalid_bet_currency do
      bet_amount_currency     ''
    end

    factory :invalid_bet_amount do
      bet_amount              0
    end

    factory :bet_complete do
      bet_amount              100
      bet_amount_currency     'EUR'
      user
      account

      multiplier              2

      win_amount              200
      win_amount_currency     'EUR'

      win_amount_eur          200
      win_amount_eur_currency 'EUR'

      factory :eur_bet do
        bet_amount_currency   'EUR'
      end

      factory :usd_bet do
        bet_amount_currency   'USD'
      end
    end
  end
end
