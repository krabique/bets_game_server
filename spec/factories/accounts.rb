# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    amount            10000
    amount_currency   'EUR'
    user

    factory :eur_account do
      amount_currency   'EUR'
    end

    factory :usd_account do
      amount_currency   'USD'
    end
  end
end
