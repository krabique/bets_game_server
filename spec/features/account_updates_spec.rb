require 'rails_helper'

RSpec.feature "AccountUpdates", type: :feature, js: true do

  # def wait_for_ajax
  #   counter = 0
  #   while page.execute_script("return $.active").to_i > 0
  #     counter += 1
  #     sleep(0.1)
  #     raise "AJAX request took longer than 5 seconds." if counter >= 50
  #   end
  # end

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
  end

  # scenario 'user places a bet and sees his account balance change',
  #   javascript: true do
  #   VCR.use_cassette('full_bet_cycle') do
  #     click_button 'Place a bet'
  #     # wait_for_ajax
  #     # expect(page).to have_content '1001.00'
  #   end
  # end
end
