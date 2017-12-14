# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :edit_action?, only: %i[edit update]

  def new
    @account = Account.new
  end

  def edit
    @account = Account.find(params[:id])
  end

  def create
    @account = Account.new(account_params.merge(user: current_user))

    if current_user.accounts.find_by(amount_currency: params[:account][:amount_currency])
      flash.now[:alert] = "You already have a #{@account.amount_currency} account! Please choose a different currency."
      render :new
    elsif @account.save
      redirect_to root_path, notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  def update
    @account = Account.find(params[:id])
    if @account.update(account_params)
      redirect_to root_path, notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  private

  def edit_action?
    @edit_action = true
  end

  def account_params
    params_to_permit = %i[amount]

    params_to_permit << :amount_currency unless @edit_action

    params.require(:account).permit(params_to_permit)
  end
end
