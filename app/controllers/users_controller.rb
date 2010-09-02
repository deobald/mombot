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
    
    vote = Vote.for(@pez, user)
    if vote
      puts "changing approval to: #{@approve}"
      vote.approve = @approve
      vote.save!
    else
      puts "creating vote: #{user.inspect}, #{@pez.inspect}, #{@approve.inspect}"
      Vote.create! :user => user, :pez => @pez, :approve => @approve
    end
    show_candy
  end
  
  def show_candy
    render :partial => 'candy', :collection => new_candy
  end

end