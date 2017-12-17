# frozen_string_literal: true

require 'rails_helper'
require 'support/maximum_bet_helper'

RSpec.describe MaximumBet do
  before(:each) do
    MoneyRails.default_bank.update_rates(
      Rails.root.join('spec', 'support', 'exchange_rates.xml')
    )
  end

  describe 'returns the maximum possible bet at the moment ' \
     '(1/2 profit for past 24 hours + the minimal bet) in EUR' do

    it 'should return 1.0 (the minimal bet) when there was no bets' do
      expect(MaximumBetHelper.new.send(:maximum_bet_eur).to_f).to eq 1.0
    end

    it 'should return 1.0 (the minimal bet) when the profit is below 0' do
      user = create(:user)
      account = create(:account, user: user)

      bet_params = {
        bet_amount_cents: 100, bet_amount_currency: 'USD',
        win_amount_cents: 200, win_amount_currency: 'USD',
        account: account, user: user,
        win_amount_eur_cents: 169, win_amount_eur_currency: 'EUR',
        multiplier: 2
      }

      10.times { Bet.create!(bet_params) }

      expect(MaximumBetHelper.new.send(:maximum_bet_eur).to_f).to eq 1.0
    end

    it 'should return 6.0 EUR when the profit is 10.0 EUR' do
      user = create(:user)
      account = create(:eur_account, user: user)

      bet_params = {
        bet_amount_cents: 100, bet_amount_currency: 'EUR',
        win_amount_cents: 0, win_amount_currency: 'EUR',
        account: account, user: user,
        win_amount_eur_cents: 0, win_amount_eur_currency: 'EUR',
        multiplier: 0
      }

      10.times { Bet.create!(bet_params) }

      expect(MaximumBetHelper.new.send(:maximum_bet_eur).to_f).to eq 6.0
    end

    it 'should return 5.25 EUR when the profit is 10.0 USD ' \
       '(converted to EUR)' do
      user = create(:user)
      account = create(:eur_account, user: user)

      bet_params = {
        bet_amount_cents: 100, bet_amount_currency: 'USD',
        win_amount_cents: 0, win_amount_currency: 'USD',
        account: account, user: user,
        win_amount_eur_cents: 0, win_amount_eur_currency: 'EUR',
        multiplier: 0
      }

      10.times { Bet.create!(bet_params) }

      expect(MaximumBetHelper.new.send(:maximum_bet_eur).to_f).to eq 5.25
    end
  end
end
