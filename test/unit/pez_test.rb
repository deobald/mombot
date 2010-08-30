
require 'test_helper'

class PezTest < ActiveSupport::TestCase
  
  test "should bump priority on each pez" do
    first = Pez.create! :identity => 'steven', :colour => 'red'
    second = Pez.create! :identity => 'conrad', :colour => 'blue'
    assert second.priority > first.priority
  end

end
