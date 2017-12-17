# frozen_string_literal: true

require 'rails_helper'
require 'support/bank_helper'

RSpec.describe MoneyHelpers do
  it 'downloads the latest currency exchange rates' do
    path_to_file = Rails.root.join('tmp', 'exchange_rates.xml').to_s
    File.delete(path_to_file) if File.exist?(path_to_file)

    VCR.use_cassette('currency_exchange_rates_update') do
      BankHelper.new.send(:update_exchange_rates)
    end

    expect(File.exist?(path_to_file)).to be true
  end
end
