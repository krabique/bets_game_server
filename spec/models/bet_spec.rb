require 'rails_helper'

RSpec.describe Bet, type: :model do
  include CommonHelpers

  context 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:user) }
  end

  context 'validations' do
    it 'monetizes bet_amount_cents' do
      is_expected.to monetize(:bet_amount_cents)
    end

    it 'monetizes win_amount_cents' do
      is_expected.to monetize(:win_amount_cents)
    end

    it 'monetizes win_amount_eur_cents' do
      is_expected.to monetize(:win_amount_eur_cents)
    end

    it { should validate_presence_of :bet_amount_currency }
    it {
      should validate_inclusion_of(:bet_amount_currency)
        .in_array(all_currencies)
    }

    it { should validate_presence_of :win_amount_currency }

    it { should validate_presence_of :win_amount_eur_currency }
    it {
      should validate_inclusion_of(:bet_amount_currency)
        .in_array(%w[EUR])
    }

    it { should validate_presence_of :account }
    it { should validate_presence_of :user }

    it { should validate_presence_of :multiplier }
    it {
      should validate_inclusion_of(:multiplier)
        .in_array([0, 1, 2])
    }
  end
end
