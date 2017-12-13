# frozen_string_literal: true

json.extract! bet, :id, :created_at, :updated_at
json.url bet_url(bet, format: :json)
