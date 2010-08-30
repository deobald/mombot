require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase

  self.use_instantiated_fixtures  = true
  fixtures :all

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "localhost"
  end

  test "should authenticate an existing user" do
    post :login, :user => { :identity => "bob", :password => "test" }
    assert session[:user]
    assert_equal @bob, session[:user]
    assert_response :redirect
    assert_redirected_to :controller => 'users', :action => 'welcome'
  end

  test "should login after signup" do
    post :signup, :user => { :identity => "newbob", :password => "newpassword", :password_confirmation => "newpassword", :email => "newbob@mcbob.com" }
    assert_response :redirect
    assert_not_nil session[:user]
    assert session[:user]
    assert_redirected_to :controller => 'users', :action => 'welcome'
  end
  
  test "should fail a bad signup" do
    post :signup, :user => { :identity => "newbob", :password => "newpassword", :password_confirmation => "wrong" , :email => "newbob@mcbob.com"}
    assert_response :success
    assert_template "users/signup.erb"
    assert_nil session[:user]
  
    post :signup, :user => { :identity => "yo", :password => "newpassword", :password_confirmation => "newpassword" , :email => "newbob@mcbob.com"}
    assert_response :success
    assert_template "users/signup.erb"
    assert_nil session[:user]
  
    post :signup, :user => { :identity => "yo", :password => "newpassword", :password_confirmation => "wrong" , :email => "newbob@mcbob.com"}
    assert_response :success
    assert_template "users/signup.erb"
    assert_nil session[:user]
  end
  
  test "should fail login with bad password" do
    post :login, :user=> { :identity => "bob", :password => "not_correct" }
    assert_response :success
    assert_nil session[:user]
    assert flash[:warning]
    assert_template "users/login.erb"
  end
  
  test "should logoff" do
    post :login, :user=>{ :identity => "bob", :password => "test"}
    assert_response :redirect
    assert session[:user]
    get :logout
    assert_response :redirect
    assert_nil session[:user]
    assert_redirected_to :action => 'login'
  end
  
  test "should email forgotten passwords" do
    #we can login
    post :login, :user => { :identity => "bob", :password => "test"}
    assert_response :redirect
    assert session[:user]
    #logout
    get :logout
    assert_response :redirect
    assert_nil session[:user]
    #enter an email that doesn't exist
    post :forgot_password, :user => {:email=>"notauser@doesntexist.com"}
    assert_response :success
    assert_nil session[:user]
    assert_template "users/forgot_password.erb"
    assert flash[:warning]
    #enter bobs email
    post :forgot_password, :user => {:email=>"exbob@mcbob.com"}   
    assert_response :redirect
    assert flash[:message]
    assert_redirected_to :action => 'login'
  end
  
  test "should require login to see protected pages" do
    #can't access welcome if not logged in
    get :welcome
    assert flash[:warning]
    assert_response :redirect
    assert_redirected_to :controller => 'users', :action => 'login'
    #login
    post :login, :user => { :identity => "bob", :password => "test"}
    assert_response :redirect
    assert session[:user]
    #can access it now
    get :welcome
    assert_response :success
    assert_nil flash[:warning]
    assert_template "users/welcome.erb"
  end
  
  test "should disable old password when password changes" do
    #can login
    post :login, :user=>{ :identity => "bob", :password => "test"}
    assert_response :redirect
    assert session[:user]
    #try to change password
    #passwords dont match
    post :change_password, :user=>{ :password => "newpass", :password_confirmation => "newpassdoesntmatch"}
    assert_response :success
    assert session[:user].errors['password']
    #empty password
    post :change_password, :user=>{ :password => "", :password_confirmation => ""}
    assert_response :success
    assert session[:user].errors['password']
    #success - password changed
    post :change_password, :user=>{ :password => "newpass", :password_confirmation => "newpass"}
    assert_response :success
    assert flash[:message]
    assert_template "users/change_password.erb"
    #logout
    get :logout
    assert_response :redirect
    assert_nil session[:user]
    #old password no longer works
    post :login, :user=> { :identity => "bob", :password => "test" }
    assert_response :success
    assert_nil session[:user]
    assert flash[:warning]
    assert_template "users/login.erb"
    #new password works
    post :login, :user=>{ :identity => "bob", :password => "newpass"}
    assert_response :redirect
    assert session[:user]
  end
  
  test "should return to login-required page" do
    #cant access hidden without being logged in
    get :hidden
    assert flash[:warning]
    assert_response :redirect
    assert_redirected_to :controller => 'users', :action => 'login'
    assert session[:return_to]
    #login
    post :login, :user=>{ :identity => "bob", :password => "test"}
    assert_response :redirect
    #redirected to hidden instead of default welcome
    assert_redirected_to :controller => 'users', :action => 'hidden'
    assert_nil session[:return_to]
    assert session[:user]
    assert flash[:message]
    #logout and login again
    get :logout
    assert_nil session[:user]
    post :login, :user=>{ :identity => "bob", :password => "test"}
    assert_response :redirect
    #this time we were redirected to welcome
    assert_redirected_to :controller => 'users', :action => 'welcome'
  end
end
