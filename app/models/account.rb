# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user
  has_many :bets

  monetize :amount_cents
  validates :amount_currency, presence: true, inclusion:
    { in: all_currencies }

  validates :user, presence: true
end
