# frozen_string_literal: true

class Api::V2::UserAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :load_user_account, only: %i[update destroy]

  def index
    movements = UserAccount.all.unscoped.ordered.includes(:user, :account)

    render(
      json: movements.to_json(
        only: %i[id active in_date out_date],
        include: {
          user: { only: %i[email name] },
          account: { only: %i[name client_name] }
        }
      ),
      status: :ok
    )
  end

  def create
    user = User.find_by(id: params[:user_id].html_safe)
    return_not_found unless user

    account = Account.find_by(id: params[:account_id].html_safe)
    return_not_found unless account

    user_account = UserAccount.new(user_id: user.id, account_id: account.id, in_date: params[:in_date]&.html_safe || Time.now.to_datetime)
    return return_errors(user_account) unless user_account.save

    render(
      json: user_account.to_json(
        only: %i[id active in_date out_date],
        include: {
          user: { only: %i[email name] },
          account: { only: %i[name client_name] }
        }
      ),
      status: :ok
    )
  end

  def update
    @user_account.in_date = params[:in_date].html_safe if params[:in_date]
    @user_account.out_date = params[:out_date].html_safe if params[:out_date]

    return return_errors(@user_account) unless @user_account.save

    render(
      json: @user_account.to_json(
        only: %i[id active in_date out_date],
        include: {
          user: { only: %i[email name] },
          account: { only: %i[name client_name] }
        }
      ),
      status: :ok
    )
  end

  def destroy
    return return_errors(@user_account) unless @user_account.inactive!

    render(
      json: @user_account.to_json(
        only: %i[id active in_date out_date],
        include: {
          user: { only: %i[email name] },
          account: { only: %i[name client_name] }
        }
      ),
      status: :ok
    )
  end

  private

  def load_user_account
    @user_account = UserAccount.find_by(id: params[:id].html_safe)
    return return_not_found unless @user_account
  end
end
