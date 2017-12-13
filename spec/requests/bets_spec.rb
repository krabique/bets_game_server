require 'rails_helper'

RSpec.describe "Bets", type: :request do
  describe "GET /bets" do
    it "works! (now write some real specs)" do
      get bets_path
      expect(response).to have_http_status(200)
    end
  end
end
