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
    multiplier = get_random_multiplier
    currency = params[:bet][:bet_amount_currency]
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

    if account.amount >= bet_amount.to_money(currency) && !bet_amount.zero?
      Bet.transaction do
        respond_to do |format|
          if @bet.save
            @bet.account.update!(amount: @bet.account.amount - bet_amount + win_amount)
            format.html { redirect_to root_path, notice: 'Bet was successfully created.' }
            format.json { render :show, status: :created, location: @bet }
          else
            format.html { render :new }
            format.json { render json: @bet.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      redirect_to root_path, notice: 'Insufficient funds!'
    end
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

  def get_random_multiplier
    require 'httparty'

    random_org_response = HTTParty.post('https://api.random.org/json-rpc/1/invoke',
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
                                        }.to_json).body

    JSON(random_org_response)['result']['random']['data'][0]
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
