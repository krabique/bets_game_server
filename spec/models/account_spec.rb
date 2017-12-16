require 'rails_helper'

RSpec.describe Account, type: :model do
  include CommonHelpers

  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:bets) }
  end

  context 'validations' do
    it 'monetizes amount_cents' do
      is_expected.to monetize(:amount_cents)
    end

    it { should validate_presence_of :amount_currency }
    it {
      should validate_inclusion_of(:amount_currency)
        .in_array(all_currencies)
    }
    it { should validate_presence_of :user }
  end
end
