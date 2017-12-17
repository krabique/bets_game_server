# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    context 'when user is not logged in' do
      it 'should redirect to the log in page' do
        get :index

        expect(response.status).to redirect_to :new_user_session
      end
    end

    context 'when user is logged in' do
      let(:user) { create(:user) }

      before(:each) do
        sign_in user
        get :index
      end

      it 'should set @bet to a new bet' do
        expect(assigns(:bet).attributes).to eq Bet.new.attributes
      end

      it "should set @accounts to current user's accounts" do
        expect(assigns(:accounts)).to eq user.accounts
      end

      it "should set @bets_log to current user's last 5 bets descending" do
        5.times { create(:bet_complete) }

        expect(assigns(:bets_log)).to eq user.bets.last(5).reverse
      end

      it 'should set @top_wins to 5 top wins of all time' do
        5.times { create(:bet_complete) }

        expect(assigns(:top_wins)).to eq(
          Bet.order('win_amount_eur_cents DESC').limit(5).includes(:user)
        )
      end
    end
  end
end
