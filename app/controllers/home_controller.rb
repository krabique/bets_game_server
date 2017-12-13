# frozen_string_literal: true

class HomeController < ApplicationController
  # skip_before_action :authenticate_user!, :only => [:index]

  def index
    @bet = Bet.new
    @accounts = current_user.accounts
  end
end
