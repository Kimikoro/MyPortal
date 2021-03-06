class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include OAuthService
  include OAuthPolicy

  # deviceのコントローラーのときに、下記のメソッドを呼ぶ
  before_action :configure_permitted_parameters, if: :devise_controller?


  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
