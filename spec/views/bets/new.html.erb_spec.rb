require 'rails_helper'

RSpec.describe "bets/new", type: :view do
  before(:each) do
    assign(:bet, Bet.new())
  end

  it "renders new bet form" do
    render

    assert_select "form[action=?][method=?]", bets_path, "post" do
    end
  end
end
