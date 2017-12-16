# frozen_string_literal: true

FactoryBot.define do
  factory :bet do
    bet_amount          100
    bet_amount_currency 'EUR'
    user
    account

    factory :eur_bet do
      bet_amount_currency 'EUR'
    end

    factory :usd_bet do
      bet_amount_currency 'USD'
    end
  end
end
