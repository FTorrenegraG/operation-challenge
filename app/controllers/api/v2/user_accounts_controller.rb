# frozen_string_literal: true

class Api::V2::UserAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :load_user_account, only: %i[update destroy]

  def index
    movements = UserAccount.eager_load(:user, :account).ordered

    movements = search_by_account(movements, params[:accounts]) if params[:accounts]
    movements = search_by_user(movements, params[:users]) if params[:users]
    movements = search_by_date(movements, params[:in_date], 'in') if params[:in_date]
    movements = search_by_date(movements, params[:out_date], 'out') if params[:out_date]

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
    return return_not_found unless user

    account = Account.find_by(id: params[:account_id].html_safe)
    return return_not_found unless account

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
      status: :created
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

  def search_by_date(movements, date_ps, in_out)
    selected_date = Date.parse(date_ps.html_safe)
    if in_out == 'in'
      movements.where(in_date: selected_date.all_day)
    else
      movements.where(out_date: selected_date.all_day)
    end
  end

  def search_by_account(movements, account_ps)
    movements = movements.where('accounts.name like ?', "%#{account_ps[:name].html_safe}%") if account_ps[:name]
    movements = movements.where('accounts.client_name like ?', "%#{account_ps[:client_name].html_safe}%") if account_ps[:client_name]
    movements
  end

  def search_by_user(movements, user_ps)
    movements = movements.where('users.name like ?', "%#{user_ps[:name].html_safe}%") if user_ps[:name]
    movements = movements.where('users.email like ?', "%#{user_ps[:email].html_safe}%") if user_ps[:email]
    movements
  end

  def load_user_account
    @user_account = UserAccount.find_by(id: params[:id].html_safe)
    return return_not_found unless @user_account
  end
end
