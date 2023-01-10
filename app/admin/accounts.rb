ActiveAdmin.register Account do

  menu if: proc { current_user.admin? || current_user.super_admin? }
  permit_params :name, :client_name, :manager_name
  
end
