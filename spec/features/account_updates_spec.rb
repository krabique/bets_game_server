require 'rails_helper'

RSpec.feature "AccountUpdates", type: :feature, js: true do
  before(:each) do
    visit '/users/sign_up'

    within('#new_user') do
      fill_in 'user_email', with: 'names@namie.com'
      fill_in 'user_password', with: 'abcd1234'
      fill_in 'user_password_confirmation', with: 'abcd1234'
    end

    click_button 'Sign up'

    Account.create!(amount: 1000, amount_currency: 'USD', user: User.last)

    within('#new_bet') do
      fill_in 'bet_bet_amount', with: '1'
      select('USD', from: 'bet_bet_amount_currency')
    end

    VCR.use_cassette('full_bet_cycle') do
      click_button 'Place a bet'
    end
  end

  scenario 'abc', javascript: true do
  #   expect do
  #     visit '/users/sign_up'

  #     within('#new_user') do
  #       fill_in 'user_email', with: 'names@namie.com'
  #       fill_in 'user_password', with: 'abcd1234'
  #       fill_in 'user_password_confirmation', with: 'abcd1234'
  #     end

  #     click_button 'Sign up'
  #   end.to change(User, :count).by(1)
  end
end
