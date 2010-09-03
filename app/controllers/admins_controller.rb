
class AdminsController < ApplicationController
  
  def index
    @waiting = Pez.all :conditions => ['status = ?', 'waiting']
    @dispensed = Pez.all :conditions => ['status = ?', 'dispensed']
  end
  
  def seat
    @pez = Pez.find params[:pez_id]
    @pez.seat
  end
  
end