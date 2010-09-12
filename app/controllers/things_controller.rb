
class ThingsController < ApplicationController
  
  before_filter :login_required
  
  def index
    @things = Thing.all :conditions => ['previous_id is ?', nil]
  end
  
  def new
    @previous_id = params[:previous_id]
    @thing = Thing.new
  end
  
  def create
    @thing = Thing.new params[:thing]
    @thing.reply_to params[:previous_id]
    redirect_to thing_path(@thing)
  end
  
  def show
    @thing = Thing.find params[:id]
  end
  
end