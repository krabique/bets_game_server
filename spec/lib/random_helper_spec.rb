require 'rails_helper'
require 'support/random_org_api_test_helper'

RSpec.describe RandomHelper do
  describe 'when no arguments are provided' do
    it 'returns a random number from 0 to 3 from the random.org api' do
      VCR.use_cassette("random_bet_multiplier_default") do
        result = RandomOrgApiTestHelper.new.send(:random_multiplier)
        expect(result).to be_between(0, 2)
      end
    end
  end

  describe 'when an argument is provided' do
    it 'returns a random number from 0 to the provided argument from the ' \
       'random.org api' do
      VCR.use_cassette("random_bet_multiplier_five_hundred") do
        argument = 500
        result = RandomOrgApiTestHelper.new.send(:random_multiplier, argument)
        expect(result).to be_between(0, argument)
      end
    end
  end
end
