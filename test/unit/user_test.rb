require File.dirname(__FILE__) + '/../test_helper'
require "#{RAILS_ROOT}/lib/exceptions"

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
  
  test "creating a user succeeds with a secret code" do
    pez = Factory(:pez, :identity => 'sigmund').dispense
    u = User.new
    u.identity = 'sigmund'
    u.email = 'sig@freud.name'
    u.password = u.password_confirmation = 'password'
    u.secret_code = pez.secret_code
    u.save!    
  end
  
  test "creating a user fails without secret code" do
    pez = Factory(:pez, :identity => 'sigmund').dispense
    u = User.new
    u.identity = 'sigmund'
    u.email = 'sig@freud.name'
    u.password = u.password_confirmation = 'password'
    assert_raise SecretCodeError do
      u.save!
    end
  end
  
  test "creating a user fails unless secret code matches by identity" do
    pez = Factory(:pez, :identity => 'not-sigmund').dispense
    u = User.new
    u.identity = 'sigmund'
    u.email = 'sig@freud.name'
    u.password = u.password_confirmation = 'password'
    u.secret_code = pez.secret_code
    assert_raise SecretCodeError do
      u.save!
    end
  end
  
  test "creating a user changes the priority of the associated pez to zero" do
    pez = Factory(:pez, :identity => 'sigmund').dispense
    u = User.new
    u.identity = 'sigmund'
    u.email = 'sig@freud.name'
    u.password = u.password_confirmation = 'password'
    u.secret_code = pez.secret_code
    u.save!
    pez.reload
    assert_equal 0, pez.priority
  end
  
  test "finds any users who haven't voted on the current pez yet" do
    one = Factory :user
    two = Factory :user
    three = Factory :user
    four = Factory :user
    seated = Factory(:pez).seat
    seated.receive_vote_from one, true
    seated.receive_vote_from two, true
    assert_equal [three, four], User.find_unvoted
  end
  
  test "finds lazy users by determining if they have not voted on a seated pez for 8 hrs x users" do
    one = Factory :user
    two = Factory :user
    three = Factory :user
    four = Factory :user
    seated = Factory(:pez).seat
    seated.created_at = Time.utc 1999, 7, 7, 0, 0, 0
    seated.save!
    seated.receive_vote_from one, true
    seated.receive_vote_from two, true
    Time.stubs(:now).returns(Time.utc(1999, 7, 8, 9, 0, 0))
    assert_equal [three, four], User.find_lazies
  end
  
  test "finds no lazy users if (8 hrs x users) has not passed yet" do
    one = Factory :user
    two = Factory :user
    three = Factory :user
    four = Factory :user
    seated = Factory(:pez).seat
    seated.created_at = Time.utc 1999, 7, 7, 0, 0, 0
    seated.save!
    seated.receive_vote_from one, true
    seated.receive_vote_from two, true
    Time.stubs(:now).returns(Time.utc(1999, 7, 8, 7, 59, 0))
    assert_equal [], User.find_lazies
  end
  
end
