# frozen_string_literal: true

ActiveAdmin.register(User) do
  disallowed = []
  disallowed << :destroy if proc { current_user.standart? }

  actions :all, except: disallowed

  before_action :remove_password_params_if_blank, only: [:update]
  controller do
    def index
      return redirect_to(admin_user_path(current_user.id)) if current_user.standart?

      super
    end

    def show
      return redirect_to(admin_user_path(current_user.id)) if current_user.standart? && params[:id] != current_user.id.to_s

      super
    end

    private

    def remove_password_params_if_blank
      return unless params[:user][:password].blank? && params[:user][:password_confirmation].blank?

      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  end

  breadcrumb do
    if current_user.standart?
      [
        link_to('my user', admin_user_path(current_user.id))
      ]
    else
      [
        link_to('admin', admin_dashboard_path),
        link_to('users', admin_users_path)
      ]
    end
  end
  menu if: proc { current_user.admin? || current_user.super_admin? }
  permit_params :email, :name, :english_level, :knowledge, :cv_url, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :current_account do |user|
      user.account&.name || 'No Account'
    end
    actions
  end

  show do
    attributes_table do
      row :email
      row :name
      row :english_level
      row :knowledge
      row :cv_url
      row :access_level unless current_user.standart?
      row :account do |user|
        user.account&.name
      end
    end
  end

  filter :email

  form do |f|
    f.inputs do
      f.input(:email)
      f.input(:name)
      f.input(:english_level)
      f.input(:knowledge)
      f.input(:cv_url)
      f.input(:password)
      f.input(:password_confirmation)
      f.input(:access_level) if current_user.super_admin?
    end
    f.actions
  end
end
