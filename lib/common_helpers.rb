module CommonHelpers
  def all_currencies
    # Money::Currency.table.keys.map(&:upcase)
    %w[USD EUR]
  end
end
