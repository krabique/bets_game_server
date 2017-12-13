# frozen_string_literal: true

class Bet < ApplicationRecord
  belongs_to :account

  monetize :bet_amount_cents
  monetize :win_amount_cents
end
