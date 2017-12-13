module BetsHelper
  def all_currencies
    #Money::Currency.table.keys.map(&:upcase)
    ['USD', 'EUR']
  end
end
