# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BetsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/bets').to route_to('bets#create')
    end
  end
end
