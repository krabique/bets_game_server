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
    @account = Account.new(account_create_params.merge(user: current_user))

    if @account.save
      redirect_to root_path, notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  def update
    @account = Account.find(params[:id])
    if @account.update(account_update_params)
      redirect_to root_path, notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  private

  def account_update_params
    params.require(:account).permit(:amount)
  end

  def edit_action?
    @edit_action = true
  end

  def account_create_params
    params.require(:account).permit(:amount, :amount_currency)
  end
end
