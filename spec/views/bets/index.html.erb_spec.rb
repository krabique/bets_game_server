require 'rails_helper'

RSpec.describe "bets/index", type: :view do
  before(:each) do
    assign(:bets, [
      Bet.create!(),
      Bet.create!()
    ])
  end

  it "renders a list of bets" do
    render
  end
end
