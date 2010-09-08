
require 'test_helper'

class PezTest < ActiveSupport::TestCase
  
  test "bumps priority on each new pez" do
    first = Pez.create! :identity => 'steven', :colour => 'red'
    second = Pez.create! :identity => 'conrad', :colour => 'blue'
    assert second.priority > first.priority
  end
  
  test "generates a new colour on each new pez" do
    first = Pez.create! :identity => 'steven'
    second = Pez.create! :identity => 'conrad'
    assert_equal '#', first.colour[0].to_s
    assert_equal 7, first.colour.length
    assert second.colour != first.colour
  end
  
  test "only votable if it's top priority" do
    votable = Pez.create!(:identity => 'steven', :colour => 'red').seat
    not_votable = Pez.create!(:identity => 'conrad', :colour => 'blue').seat
    assert votable.votable?
    assert_false not_votable.votable?
  end
  
  test "only votable if it's top priority and seated" do
    not_seated = Pez.create!(:identity => 'firstpost', :colour => 'green').dispense
    seated = Pez.create!(:identity => 'steven', :colour => 'red').seat
    assert_false not_seated.votable?
    assert seated.votable?
  end
  
  test "has a total of current votes" do
    pez = Factory(:pez).seat
    pez.receive_vote_from Factory(:user), true
    pez.receive_vote_from Factory(:user), false
    assert_equal 2, pez.votes_so_far
  end

  test "has a total of remaining votes" do
    pez = Factory(:pez).seat
    pez.receive_vote_from Factory(:user), true
    Factory(:user)
    Factory(:user)
    Factory(:user)
    assert_equal 3, pez.votes_remaining
  end
  
  test "dispensed when last vote is cast" do
    guy = Factory(:user)
    gal = Factory(:user)
    pez = Factory(:pez).seat
    pez.receive_vote_from guy, true
    assert_equal 'seated', pez.status
    pez.receive_vote_from gal, true
    assert_equal 'dispensed', pez.status
  end
  
  test "dispensing generates a secret code" do
    gal = Factory(:user)
    pez = Factory(:pez).seat
    pez.receive_vote_from gal, true
    assert_not_equal '', pez.secret_code
  end
end
