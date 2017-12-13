require 'rails_helper'

RSpec.describe "bets/show", type: :view do
  before(:each) do
    @bet = assign(:bet, Bet.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
