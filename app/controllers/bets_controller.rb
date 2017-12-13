# frozen_string_literal: true

class BetsController < ApplicationController
  before_action :set_bet, only: %i[show edit update destroy]

  # GET /bets
  # GET /bets.json
  def index
    @bets = Bet.all
  end

  # GET /bets/1
  # GET /bets/1.json
  def show; end

  # GET /bets/new
  def new
    @bet = Bet.new
  end

  # GET /bets/1/edit
  def edit; end

  # POST /bets
  # POST /bets.json
  def create
    currency = params[:bet][:bet_amount_currency]
    raise Exceptions::NoCurrencyChosen unless currency

    multiplier = random_multiplier
    bet_amount = params[:bet][:bet_amount].to_money(currency)
    win_amount = bet_amount * multiplier
    account = current_user.accounts.find_by(
      amount_currency: currency
    )

    win_params = {
      win_amount: win_amount,
      win_amount_currency: currency
    }

    account_params = {
      account: account
    }

    complete_params = bet_params.merge(win_params).merge(account_params)

    @bet = Bet.new(complete_params)

    Bet.transaction do
      if bet_amount.zero?
        @info = "Can't bet zero! Show me what you've got, playa'!"
      elsif account.amount < bet_amount.to_money(currency)
        @info = "Insufficient funds. Mah' poor nigga'."
      else
        @bet.account.update!(amount: @bet.account.amount - bet_amount + win_amount)
        @info = "You've made a bet of #{currency} #{bet_amount} and won #{currency} #{win_amount}!"
      end
    end

    rescue
      @info = "You have to choose a valid currency!"
    ensure
      flash.now[:alert] = @info
  end

  # PATCH/PUT /bets/1
  # PATCH/PUT /bets/1.json
  def update
    respond_to do |format|
      if @bet.update(bet_params)
        format.html { redirect_to @bet, notice: 'Bet was successfully updated.' }
        format.json { render :show, status: :ok, location: @bet }
      else
        format.html { render :edit }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bets/1
  # DELETE /bets/1.json
  def destroy
    @bet.destroy
    respond_to do |format|
      format.html { redirect_to bets_url, notice: 'Bet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def random_multiplier
    random_org_response = HTTParty.post(
      'https://api.random.org/json-rpc/1/invoke',
      body: {
        'jsonrpc' => '2.0',
        'method' => 'generateIntegers',
        'params' => {
          'apiKey' => ENV['RANDOM_ORG_API_KEY'],
          'n' => 1,
          'min' => 0,
          'max' => 2,
          'replacement' => true,
          'base' => 10
        },
        'id' => 24_780
      }.to_json
    )

    JSON(random_org_response.body)['result']['random']['data'][0]
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_bet
    @bet = Bet.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bet_params
    params.require(:bet).permit(:bet_amount, :bet_amount_currency)
  end
end
