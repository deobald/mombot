require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "finds pez without votes from this user" do
    pez = Factory(:pez).seat
    user = Factory :user
    assert_equal [pez], user.dispenser
  end
  
  test "only finds seated pez without votes from this user" do
    waiting = Factory(:pez).wait
    seated = Factory(:pez).seat
    dispensed = Factory(:pez).dispense
    user = Factory :user
    assert_equal [seated], user.dispenser
  end
  
  test "knows if this user liked a pez" do
    liked = Factory(:pez).seat
    user = Factory :user
    like = Factory :vote, :user => user, :pez => liked, :approve => true
    assert_equal 'liked', user.liked(liked)
    assert_equal '', user.disliked(liked)
  end
  
  test "knows if this user disliked a pez" do
    liked = Factory(:pez).seat
    user = Factory :user
    like = Factory :vote, :user => user, :pez => liked, :approve => false
    assert_equal '', user.liked(liked)
    assert_equal 'disliked', user.disliked(liked)
  end
  
  test "creating a user fails without secret code" do
    pez = Factory(:pez, :identity => 'sigmund').dispense
    u = User.new
    u.identity = 'sigmund'
    u.email = 'sig@freud.name'
    u.password = u.password_confirmation = 'password'
    assert_raise Exception do
      u.save!
    end
  end
  
  # u.secret_code = pez.secret_code
  # assert u.save
  

end
