# frozen_string_literal: true

class RecurrentUpdateExchangeRateJob < ApplicationJob
  include MoneyHelpers

  queue_as :default

  after_perform do
    # Schedule the update to the next whole hour, i.e. if an initial
    # update was at 13:43:12 today (on the server's start up), the next
    # one will be at 14:00:00 today.
    time = Time.now
    time = time - (time.min * 60) - time.sec + 1.hour

    self.class.set(wait_until: time).perform_later
  end

  def perform
    update_exchange_rates
    raise StandardError
  rescue => e
    logger.fatal 'RecurrentUpdateExchangeRateJob raised an exception - ' \
                 "#{e}: \n" \
                 "#{e.backtrace.join("\n")}"
  end
end
