# frozen_string_literal: true

class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params.merge(user: current_user))

    if @account.save
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

  def account_params
    params.require(:account).permit(:amount, :amount_currency)
  end
end
