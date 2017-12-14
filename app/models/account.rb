# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user

  monetize :amount_cents
  validates :amount_currency, presence: true, inclusion:
    { in: all_currencies }
end
