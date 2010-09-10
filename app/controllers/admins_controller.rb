
class AdminsController < ApplicationController
  include Authentication
  
  before_filter :admin_login_required, :only => ['index', 'seat']
  
  def index
    @waiting = Pez.all :conditions => ['status = ?', 'waiting']
    @dispensed = Pez.all :conditions => ['status = ? and priority > 0', 'dispensed']
  end
  
  def seat
    @pez = Pez.find params[:pez_id]
    @pez.seat
  end
  
  def adminify
    return unless request.post?
    @why_not = ""
    if no_admin_exists_yet || you_are_admin
      @who = params[:who]
      flash[:message] = "You adminified #{@who}"
    else
      flash[:warning] = "Bad dog! No milkdud. [ #{@why_not} ]"
    end
  end
  
  def no_admin_exists_yet
    admins = User.all(:conditions => ['admin = ?', true])
    if admins
      names = admins.map {|a| a.identity}.join(', ')
      @why_not << " Admin(s) exist already: #{names}. "
      return false
    end
    return true
  end
  
  def you_are_admin
    unless session[:user] && session[:user].admin?
      @why_not << " You are no admin! "
      return false
    end
    return true
  end
end
