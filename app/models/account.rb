# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user

  monetize :amount_cents
end
