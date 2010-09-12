
class ThingsController < ApplicationController
  
  before_filter :login_required
  
  def index
    @things = Thing.all :conditions => ['previous is ?', nil]
  end
  
  def new
    @thing = Thing.new
  end
  
  def create
    @thing = Thing.new params[:thing]
    @thing.save!
    redirect_to thing_path(@thing)
  end
  
  def show
    @thing = Thing.find params[:id]
  end
  
end