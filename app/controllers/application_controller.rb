# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  layout 'main'

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def with_login_requirement message
    # TODO: next
  end
  
  def login_required
    if current_user
      return true
    end
    flash[:warning] = 'Please login to continue'
    session[:return_to] = request.request_uri
    redirect_to :controller => "users", :action => "login"
    return false
  end
  
  def admin_login_required
    if current_user && current_user.admin?
      return true
    end
    flash[:warning] = 'Please login as an administrator to continue'
    session[:return_to] = request.request_uri
    redirect_to :controller => "users", :action => "login"
    return false
  end

  def current_user
    session[:user]
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
