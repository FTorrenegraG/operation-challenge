# frozen_string_literal: true

ActiveAdmin.register(User) do
  disallowed = []
  disallowed << :destroy if proc { current_user.standart? }

  actions :all, except: disallowed

  controller do
    def index
      return redirect_to(admin_user_path(current_user.id)) if current_user.standart?

      super
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
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email

  form do |f|
    f.inputs do
      f.input(:email)
      f.input(:password)
      f.input(:password_confirmation)
    end
    f.actions
  end
end
