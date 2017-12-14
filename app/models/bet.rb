# frozen_string_literal: true

class Bet < ApplicationRecord
  belongs_to :account
  belongs_to :user

  monetize :bet_amount_cents
  monetize :win_amount_cents

  validates :bet_amount_currency, presence: true, inclusion:
    { in: all_currencies }
end
