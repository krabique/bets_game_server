# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    let(:account) { create(:account, user: user) }

    it 'renders the :edit template' do
      get :edit, params: { id: account.id }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new account in the database' do
        expect do
          post :create, params: { account: attributes_for(:account) }
        end.to change(Account, :count).by(1)
      end

      it 'redirects to the home page' do
        post :create, params: { account: attributes_for(:account) }
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new account in the database' do
        expect do
          post :create, params: { account: attributes_for(:invalid_account) }
        end.to_not change(Account, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { account: attributes_for(:invalid_account) }
        expect(response).to render_template :new
      end
    end

    context 'when trying to create an account with a currency that this ' \
            'user already have an account with' do

      it 'does not save the new account in the database' do
        currency = 'EUR'

        create(:account, amount_currency: currency, user: user)

        expect do
          post :create, params:
            { account: attributes_for(:account, amount_currency: currency) }
        end.to_not change(Account, :count)
      end

      it 're-renders the :new template with a flash' do
        currency = 'EUR'

        create(:account, amount_currency: currency, user: user)

        post :create, params:
          { account: attributes_for(:account, amount_currency: currency) }

        expect(response).to render_template :new
        expect(flash[:alert]).to eq "You already have a #{currency} acc!"
      end
    end
  end

  describe 'PUT #update' do
    let(:account) { create(:account, user: user) }

    context 'with valid attributes' do
      it "changes the account's amount and saves it to the database" do
        amount = rand(1000)

        put :update, params: { id: account.id, account: { amount: amount } }

        assigns(:account).reload

        expect(assigns(:account).amount.to_f).to eq amount
      end

      it 'redirects to the home page' do
        amount = rand(1000)
        put :update, params: { id: account.id, account: { amount: amount } }
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid attributes' do
      context 'for amount' do
        it 'does not update the account' do
          initial_amount = account.amount

          put :update, params: { id: account.id, account: { amount: 'abc' } }

          assigns(:account).reload

          expect(assigns(:account).amount).to eq initial_amount
        end

        it 're-renders the :new template' do
          put :update, params: { id: account.id, account: { amount: 'abc' } }

          expect(response).to render_template :edit
        end
      end

      context 'for currency (should not be possible to change)' do
        it 'does not update the account' do
          initial_amount_currency = account.amount_currency

          put :update, params: { id: account.id, account:
            { amount: '123', amount_currency: 'ABC' } }

          assigns(:account).reload

          expect(assigns(:account).amount_currency)
            .to eq initial_amount_currency
        end
      end
    end

    context "when user is trying to update someone else's account" do
      it 'should not update the account' do
        other_user_account = create(:account, user: create(:user))

        initial_amount = other_user_account.amount

        put :update, params: {
          id: other_user_account.id,
          account: { amount: initial_amount.to_f + 1 }
        }

        assigns(:account).reload

        expect(assigns(:account).amount).to eq initial_amount
      end
    end
  end
end
