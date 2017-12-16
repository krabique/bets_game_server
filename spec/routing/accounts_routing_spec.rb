require "rails_helper"

RSpec.describe AccountsController, type: :routing do
  describe "routing" do

    it "routes to #new" do
      expect(:get => "/accounts/new").to route_to("accounts#new")
    end

    it "routes to #edit" do
      expect(:get => "/accounts/1/edit").to route_to("accounts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/accounts").to route_to("accounts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/accounts/1").to route_to("accounts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/accounts/1").to route_to("accounts#update", :id => "1")
    end

  end
end
