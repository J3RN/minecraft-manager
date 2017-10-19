class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    phoenixes_path
  end

  protected

  def configure_permitted_parameters
    sign_up_keys = %i[
      username
      email
      password
      password_confirmation
      access_token
    ]
    account_update_keys = sign_up_keys << :current_password

    devise_parameter_sanitizer.permit(:sign_up, keys: sign_up_keys)
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: account_update_keys)
  end
end
