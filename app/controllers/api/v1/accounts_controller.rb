# frozen_string_literal: true

class Api::V1::AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :load_account, only: %i[show update destroy]

  def create
    account = Account.new(account_params)
    return return_errors(account) unless account.save

    render(json: account, status: :created)
  end

  def index
    render(json: Account.all, status: :ok)
  end

  def show
    render(json: @account, status: :ok)
  end

  def update
    return return_errors(@account) unless @account.update(account_params)

    render(json: @account, status: :ok)
  end

  def destroy
    return return_errors(@account) unless @account.destroy

    head(:ok)
  end

  private

  def account_params
    params.require(:account).permit(:name, :client_name, :manager_name)
  end

  def load_account
    @account = Account.find_by(id: params[:id].html_safe)
    return return_not_found unless @account
  end
end
