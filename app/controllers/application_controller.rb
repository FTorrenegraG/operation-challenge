# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def return_errors(resource)
    render(json: { errors: resource.errors }, status: :unprocessable_entity)
  end

  def return_not_found
    head(:not_found)
  end

  protected

  def authenticate_admin
    return head(:unauthorized) unless current_user.admin? || current_user.super_admin?
  end
end
