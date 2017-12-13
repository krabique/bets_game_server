# frozen_string_literal: true

module BetsHelper
  def all_currencies
    # Money::Currency.table.keys.map(&:upcase)
    %w[USD EUR]
  end
end
