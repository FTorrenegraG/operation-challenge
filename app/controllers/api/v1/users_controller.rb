# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :load_user, only: %i[show update destroy]

  def create
    user = User.new(user_params)
    return head(:unauthorized) if !user.standart? && !current_user.super_admin?
    return return_errors(user) unless user.save

    render(json: user, status: :created)
  end

  def index
    render(json: User.all, status: :ok)
  end

  def show
    render(json: @user, status: :ok)
  end

  def update
    return head(:unauthorized) if user_params[:access_level] && user_params[:access_level] != 'standart' && !current_user.super_admin?
    return return_errors(@user) unless @user.update(user_params)

    render(json: @user, status: :ok)
  end

  def destroy
    return return_errors(@user) unless @user.destroy

    head(:ok)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :english_level, :knowledge, :cv_url, :access_level)
  end

  def load_user
    @user = User.find_by(id: params[:id].html_safe)
    return return_not_found unless @user
  end
end
