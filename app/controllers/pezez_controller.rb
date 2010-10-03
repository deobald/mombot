
class PezezController < ApplicationController
  
  def index
    @seated = Pez.all :order => 'priority ASC', :conditions => ['status = ?', 'seated']
    @waiting = Pez.all :order => 'priority ASC', :conditions => ['status = ?', 'waiting']
  end
  
  def new
    @pez = Pez.new_with_colour
  end
  
  def create
    @pez = Pez.new(params[:pez])
    
    respond_to do |format|
      if @pez.save
        flash[:notice] = '<div>You need to mail in an application before we can seat you.</div>'
        format.html { render :partial => "mail_in_application", :layout => "main" }
      else
        flash[:error] = 'Your pez broke for some reason. Snap dang.'
        format.html { render :action => "new" }
      end
    end
  end
  
  def show
    @pez = Pez.find(params[:id])
    respond_to do |format|
      format.html
    end
  end
end
