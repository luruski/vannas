class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      admin_root_path
    else
      root_path
    end
  end

  def after_sign_up_path_for(resource)
    root_path
  end

  helper_method :current_customer

  def current_customer
    @current_customer ||= User.find_by(id: session["warden.user.user.key"]&.first&.first)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:province_id, :address, :city, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:province_id, :address, :city, :phone])
  end
end