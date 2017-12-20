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

  def update_exchange_rates
    bank.save_rates(exchange_rates_cache)
    bank.update_rates(exchange_rates_cache)
  end

  def exchange_rates
    {
      bank_name: bank.class,
      updated_at: bank.last_updated,
      usd: bank.get_rate('EUR', 'USD')
    }
  end
end
