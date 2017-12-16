# frozen_string_literal: true

module MoneyHelpers
  private

  def all_currencies
    # Money::Currency.table.keys.map(&:upcase)
    %w[USD EUR]
  end

  def bank
    MoneyRails.default_bank
  end

  def exchange_rates_cache
    "#{Rails.root}/tmp/exchange_rates.xml"
  end
end
