class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  helper_method :current_user?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied!"
    redirect_to root_url
  end


  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to error_url
  end

  

  
  private
  def current_user?
    redirect_to(root_url, :notice => "You have to be logged in.") unless current_user
  end
  
  def current_user
    return @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

end
