class UsersController < ApplicationController

  include Authentication
  include UsersHelper # fuck you, rails -- isn't this shit free?
  
  before_filter :login_required, :only => ['welcome', 'change_password', 'show_candy', 'vote']

  def welcome
  end
  
  def vote
    @pez = Pez.find params[:pez_id]
    @approve = params[:approve] || false
    user = session[:user]
    
    @pez.receive_vote_from user, @approve
    show_candy
  end
  
  def show_candy
    render :partial => 'candy', :collection => new_candy
  end
  
end