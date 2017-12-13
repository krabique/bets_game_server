# frozen_string_literal: true

json.array! @bets, partial: 'bets/bet', as: :bet
