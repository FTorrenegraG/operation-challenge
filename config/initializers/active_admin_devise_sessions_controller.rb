class ActiveAdmin::Devise::SessionsController
  def after_sign_in_path_for(resource)
    if resource.standart?
      admin_user_path(resource.id)
    else
      admin_dashboard_path
    end
  end
end