
module Authentication

  def signup
    @user = User.new(params[:user])
    return unless request.post?

    if @user.save
      session[:user] = User.authenticate(@user.identity, @user.password)
      flash[:message] = "Signup successful"
      redirect_to :action => "welcome"          
    else
      flash[:warning] = "Signup unsuccessful"
    end
  rescue SecretCodeError
    flash[:warning] = "Signup unsuccessful: the secret code you entered is invalid."
  end

  def login
    if request.post?
      if session[:user] = User.authenticate(params[:user][:identity], params[:user][:password])
        flash.clear
        flash[:message]  = "Login successful"
        redirect_to_stored
      else
        flash[:warning] = "Login unsuccessful"
      end
    end
  end

  def logout
    session[:user] = nil
    flash[:message] = 'Logged out'
    redirect_to :action => 'login'
  end

  def forgot_password
    if request.post?
      u= User.find_by_email(params[:user][:email])
      if u and u.send_new_password
        flash[:message]  = "A new password has been sent by email."
        redirect_to :action=>'login'
      else
        flash[:warning]  = "Couldn't send password"
      end
    end
  end

  def change_password
    @user=session[:user]
    if request.post?
      @user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      if @user.save
        flash[:message]="Password Changed"
      end
    end
  end
  
  
end