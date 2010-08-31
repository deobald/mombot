
class PezezController < ApplicationController
  
  def index
    @seated = Pez.all :order => 'priority ASC', :conditions => ['status = ?', 'seated']
    @waiting = Pez.all :order => 'priority ASC', :conditions => ['status = ?', 'waiting']
  end
  
  def new
    @pez = Pez.new
  end
  
  def create
    @pez = Pez.new(params[:pez])
    
    respond_to do |format|
      if @pez.save
        flash[:notice] = 'You have been seated.'
        format.html { redirect_to(@pez) }
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