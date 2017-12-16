# frozen_string_literal: true

class Bet < ApplicationRecord
  belongs_to :account
  belongs_to :user

  monetize :bet_amount_cents
  monetize :win_amount_cents
  monetize :win_amount_eur_cents

  validates :bet_amount_currency, presence: true, inclusion:
    { in: all_currencies }
  validates :win_amount_currency, presence: true
  validates :win_amount_eur_currency, presence: true, inclusion: { in: ['EUR'] }

  validates :account, presence: true
  validates :user, presence: true

  validates :multiplier, presence: true, inclusion: { in: [0, 1, 2] }
end
