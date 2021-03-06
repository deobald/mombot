# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  layout 'main'

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def with_login_requirement failure_message
    if yield
      return true
    end
    flash[:warning] = failure_message
    session[:return_to] = request.request_uri
    redirect_to :controller => "users", :action => "login"
    return false
  end
  
  def login_required
    with_login_requirement('Please login to continue') { current_user }
  end
  
  def admin_login_required
    with_login_requirement('Please login as an administrator to continue') { current_user_is_admin? }
  end

  def current_user
    session[:user]
  end
  
  def current_user_is_admin?
    current_user && current_user.admin?
  end

  def return_to_stored
    if return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to return_to
    else
      redirect_to :controller => 'users', :action=>'welcome'
    end
  end
end
