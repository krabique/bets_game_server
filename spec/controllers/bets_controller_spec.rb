# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BetsController, type: :controller do
  let(:user) { create(:user) }

  before(:each) do
    allow_any_instance_of(BetProcessor).to(
      receive(:random_multiplier).and_return(2)
    )

    sign_in user

    create(:eur_account, user: user)
  end

  describe 'POST #create' do
    context 'with valid attributes (only amount and currency)' do
      it 'saves the new bet in the database' do
        expect do
          post :create,
               params: { bet: attributes_for(:bet) },
               format: :js
        end.to change(Bet, :count).by(1)
      end

      it "shows a flash with the bet's info" do
        post :create,
             params: { bet: attributes_for(:bet) },
             format: :js
        expect(flash.now[:notice]).to match(/You've made a bet of/)
      end

      context 'does not save the new bet in the database' do
        it 'and shows a flash about user being banned if ' \
           'randomizer returns 0' do
          allow_any_instance_of(BetProcessor).to(
            receive(:random_multiplier).and_return(0)
          )

          expect do
            post :create,
                 params: { bet: attributes_for(:bet) },
                 format: :js
          end.to_not change(Account, :count)
          expect(flash.now[:alert]).to match(
            /You are banned! You cheater, you!/
          )
        end

        it 'and shows a flash about bet amount exceeding the maximum ' \
           'allowed bet at the moment if it exceeds it (in EUR)' do
          expect do
            post :create,
                 params:
                  { bet: { bet_amount: 1.01, bet_amount_currency: 'EUR' } },
                 format: :js
          end.to_not change(Account, :count)
          expect(flash.now[:alert]).to match(
            /Your bet exceeds the maximum bet of/
          )
        end

        it 'and shows a flash about bet amount exceeding the maximum ' \
           'allowed bet at the moment if it exceeds it (in EUR)' do
          create(:account, amount: 0.5, user: user, amount_currency: 'USD')

          expect do
            post :create,
                 params: { bet: { bet_amount: 1, bet_amount_currency: 'USD' } },
                 format: :js
          end.to_not change(Account, :count)
          expect(flash.now[:alert]).to match(
            /Insufficient funds/
          )
        end
      end
    end

    context 'with invalid attributes' do
      context 'does not save the new bet in the database' do
        it 'and shows a flash about invalid amount' do
          expect do
            post :create,
                 params: { bet: attributes_for(:invalid_bet_amount) },
                 format: :js
          end.to_not change(Account, :count)
          expect(flash.now[:alert]).to match(
            /Can't bet zero! Show me what you've got, playa'!/
          )
        end

        it 'and shows a flash about invalid currency' do
          expect do
            post :create,
                 params: { bet: attributes_for(:invalid_bet_currency) },
                 format: :js
          end.to_not change(Account, :count)
          expect(flash.now[:alert]).to match(
            /You have to choose a valid currency!/
          )
        end

        it 'and shows a flash about user not having a specific currency ' \
           "account when user actually doesn't have an account with such a " \
           'currency' do
          expect do
            post :create,
                 params: { bet: { bet_amount: 1, bet_amount_currency: 'USD' } },
                 format: :js
          end.to_not change(Account, :count)
          expect(flash.now[:alert]).to match(
            /You don't have a USD account./
          )
        end
      end

      # it 're-renders the :new template' do
      #   post :create, params: { account: attributes_for(:invalid_account) }
      #   expect(response).to render_template :new
      # end
    end

    # context 'when trying to create an account with a currency that this ' \
    #         'user already have an account with' do

    #   it 'does not save the new account in the database' do
    #     currency = 'EUR'

    #     create(:account, amount_currency: currency, user: user)

    #     expect do
    #       post :create, params: { account: attributes_for(:account,
    #         amount_currency: currency) }
    #     end.to_not change(Account, :count)
    #   end

    #   it 're-renders the :new template with a flash' do
    #     currency = 'EUR'

    #     create(:account, amount_currency: currency, user: user)

    #     post :create, params: { account: attributes_for(:account,
    #       amount_currency: currency) }

    #     expect(response).to render_template :new
    #     expect(flash[:alert]).to eq "You already have a #{currency} acc!"
    #   end
    # end
  end
end
