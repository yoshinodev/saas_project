class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
   # Whitelist the following form fields so that we can process them, if coming from a 
   # Devise control form
  before_action :configure_premitted_parameters, if: :devise_controller?
  
 
  protected
    def configure_premitted_parameters
      devise_parameter_sanitizer.permit(:signup) { |u| u.permit(:stripe_card_token, :email, :password, :password_confirmation) }
    end
  
end
