
class AdminsController < ApplicationController
  include Authentication
  
  before_filter :admin_login_required, :only => ['index', 'seat']
  
  def index
    @waiting = Pez.all :conditions => ['status = ?', 'waiting']
    @dispensed = Pez.all :conditions => ['status = ? and priority > 0', 'dispensed']
    @lazy_users = User.find_lazies
  end
  
  def seat
    flash[:warning] = "Seat who?" and return unless params[:pez_id]
    @pez = Pez.find params[:pez_id]
    return unless request.post?
    
    @image = Image.new(params[:image_form])
    @image.save!
    @pez.image = @image
    @pez.seat
    flash[:message] = 'saved!'
  end
  
  def adminify
    return unless request.post?
    @why_not = ""
    who = params[:who]

    if no_admin_exists_yet
      Pez.first(:conditions => ['identity = ?', who]).adminify!
      flash[:message] = "You adminified the first admin: #{who}."
    elsif you_are_admin
      User.first(:conditions => ['identity = ?', who]).adminify!
      flash[:message] = "You adminified a new admin: #{who}."
    else
      flash[:warning] = "Bad dog! No milkdud. [ #{@why_not} ]"
    end
  end
  
  def no_admin_exists_yet
    if User.admins
      @why_not << " Admin(s) exist already: #{User.admins}. "
      return false
    end
    return true
  end
  
  def you_are_admin
    unless current_user_is_admin?
      @why_not << " You are no admin! "
      return false
    end
    return true
  end
end
