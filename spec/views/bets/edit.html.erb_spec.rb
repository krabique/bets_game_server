require 'rails_helper'

RSpec.describe "bets/edit", type: :view do
  before(:each) do
    @bet = assign(:bet, Bet.create!())
  end

  it "renders the edit bet form" do
    render

    assert_select "form[action=?][method=?]", bet_path(@bet), "post" do
    end
  end
end
