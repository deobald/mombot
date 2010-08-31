
class AdminsController < ApplicationController
  
  def index
    @waiting = Pez.all :conditions => ['status = ?', 'waiting']
  end
  
  def seat
    @pez = Pez.find params[:pez_id]
    @pez.seat
  end
  
end