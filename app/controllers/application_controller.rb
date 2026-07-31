class ApplicationController < ActionController::Base
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
end