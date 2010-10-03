
class ThingsController < ApplicationController
  
  before_filter :login_required
  
  def index
    @things = Thing.all :conditions => ['previous_id is ?', nil], :order => "created_at DESC"
  end
  
  def new
    @previous_id = params[:previous_id]
    @thing = Thing.new
  end
  
  def create
    @thing = Thing.new params[:thing]
    @thing.user = current_user
    @thing.reply_to params[:previous_id]
    redirect_to thing_path(@thing)
  rescue Exception => e
    flash[:error] = e.message
    redirect_to new_thing_path
  end
  
  def show
    @things = Thing.thread_for params[:id]
  end
  
end
