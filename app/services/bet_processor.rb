# frozen_string_literal: true

class BetProcessor
  # find us in lib/
  include MoneyHelper
  include MaximumBet
  include RandomHelper
  include BetParams

  attr_accessor :info

  def initialize(current_user)
    @current_user = current_user
  end

  def calculate_and_validate(bet)
    return unless (@bet = calculate_bet(bet))
    return @bet unless @info ||=
                         validate_bet_with_error_message(@bet, maximum_bet_eur)
  end

  private

  def calculate_bet(bet)
    currency = bet.bet_amount_currency
    raise Money::Currency::UnknownCurrency unless
      all_currencies.include?(currency)

    multiplier, win_amount, account = calculate_bet_attributes(bet).values
    bet.attributes = complete_params(win_amount, currency, multiplier, account)
    bet
  rescue Money::Currency::UnknownCurrency
    @info = ['alert', 'You have to choose a valid currency!']
    nil
  end

  def calculate_bet_attributes(bet)
    multiplier = random_multiplier
    bet_amount = bet.bet_amount.to_money(bet.bet_amount_currency)
    win_amount = bet_amount * multiplier
    {
      multiplier: multiplier,
      win_amount: win_amount,
      account: @current_user.accounts.find_by(amount_currency:
        bet.bet_amount_currency)
    }
  end

  # rubocop:disable Metrics/MethodLength
  #
  # Disabling MethodLength for the method as suggested in this discussion
  # https://github.com/bbatsov/rubocop/issues/494#issuecomment-339860349
  #
  # This is where all the validations go
  def validate_bet_with_error_message(bet, maximum_bet_eur)
    info =
      if !bet.account
        "You don't have a #{bet.bet_amount_currency} account."
      elsif bet.bet_amount.zero?
        "Can't bet zero! Show me what you've got, playa'!"
      elsif bet.account.amount < bet.bet_amount.to_money(
        bet.bet_amount_currency
      )
        "Insufficient funds. Mah' poor nigga'."
      elsif random_multiplier(500).zero?
        'You are banned! You cheater, you!'
      elsif maximum_bet_eur < bank.exchange(bet.bet_amount,
                                            bet.bet_amount_currency, 'EUR')
        "Your bet exceeds the maximum bet of #{bet.bet_amount_currency} " \
          "#{bank.exchange(maximum_bet_eur, 'EUR', bet.bet_amount_currency)} " \
          "(#{maximum_bet_eur.currency} #{maximum_bet_eur})"
      end

    info&.scan(/^.*$/)&.unshift('alert')
  end
  # rubocop:enable Metrics/MethodLength
end
