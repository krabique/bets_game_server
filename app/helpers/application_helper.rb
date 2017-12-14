# frozen_string_literal: true

module ApplicationHelper
  def all_currencies
    # Money::Currency.table.keys.map(&:upcase)
    %w[USD EUR]
  end
end
