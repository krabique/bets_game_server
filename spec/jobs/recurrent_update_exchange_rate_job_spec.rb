# frozen_string_literal: true

require 'rails_helper'
# require 'timecop'

RSpec.describe RecurrentUpdateExchangeRateJob, type: :job do
  describe '#perform_later' do
    it 'enqueues the job' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        RecurrentUpdateExchangeRateJob.perform_later
      end.to have_enqueued_job
    end

    # it 'enqueues itself to execute at the next whole hour' do
    #   ActiveJob::Base.queue_adapter = :test

    #   start_time = Time.new(2017, 12, 17, 14, 12, 05)
    #   next_whole_hour = Time.new(2017, 12, 17, 15, 00, 00)

    #   Timecop.freeze(start_time)

    #   RecurrentUpdateExchangeRateJob.perform_later

    #   Timecop.travel(start_time + 10.minutes)

    #   expect(RecurrentUpdateExchangeRateJob).to(
    #     have_been_enqueued.exactly(:twice)
    #   )
    # end
  end
end
