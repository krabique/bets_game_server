class RecurrentUpdateExchangeRateJob < ApplicationJob
  include CommonHelpers

  queue_as :default

  after_perform do |job|
    # Schedule the update to the next whole hour, i.e. if an initial
    # update was at 13:43:12 today (on the server's start up), the next
    # one will be at 14:00:00 today.
    time = Time.now
    time = time - (time.min * 60) - time.sec + 1.hour

    self.class.set(:wait_until => time).perform_later
  end

  def perform
    bank.save_rates(exchange_rates_cache)
    bank.update_rates(exchange_rates_cache)
  end
end
