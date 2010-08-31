class UsersController < ApplicationController

  include Authentication
  
  before_filter :login_required, :only => ['welcome', 'change_password', 'hidden', 'vote']

  def welcome
    @new_candy = session[:user].unvoted_candy
  end
  
  def vote
    @pez = Pez.find params[:pez_id]
    @approve = params[:approve] || false
    Vote.create :user => session[:user], :pez => @pez, :approve => @approve
  end
  
  def hidden
  end
end