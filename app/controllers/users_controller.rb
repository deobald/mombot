class UsersController < ApplicationController

  include Authentication
  
  before_filter :login_required, :only => ['welcome', 'change_password', 'hidden']

  def welcome
    
  end

  def hidden
  end
end