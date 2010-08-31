
module UsersHelper
  
  def yes_no
    @approve ? 'yes' : 'no'
  end
  
  def new_candy
    session[:user].unvoted_candy
  end
  
end