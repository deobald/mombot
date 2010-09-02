
require 'test_helper'

class PezTest < ActiveSupport::TestCase
  
  test "should bump priority on each pez" do
    first = Pez.create! :identity => 'steven', :colour => 'red'
    second = Pez.create! :identity => 'conrad', :colour => 'blue'
    assert second.priority > first.priority
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

end
