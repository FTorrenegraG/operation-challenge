# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, except: :show_me
  before_action :load_user, only: %i[show update destroy]
  before_action :user_authorized?, only: %i[create update]

  def create
    user = User.new(user_params)
    return return_errors(user) unless user.save

    render(json: user, status: :created)
  end

  def index
    render(json: User.all, status: :ok)
  end

  def show
    render(json: @user, status: :ok)
  end

  def show_me
    render(json: current_user, status: :ok)
  end

  def update
    return return_errors(@user) unless @user.update(user_params)

    render(json: @user, status: :ok)
  end

  def destroy
    return return_errors(@user) unless @user.destroy

    head(:ok)
  end

  private

  def user_authorized?
    return head(:unauthorized) if user_params[:access_level] && !user_valid?(user_params[:access_level])
  end

  def user_valid?(new_access_level)
    if current_user.super_admin?
      %w[admin standart].include?(new_access_level)
    elsif current_user.admin?
      new_access_level == 'standart'
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :english_level, :knowledge, :cv_url, :access_level)
  end

  def load_user
    @user = User.find_by(id: params[:id].html_safe)
    return return_not_found unless @user
  end
end
