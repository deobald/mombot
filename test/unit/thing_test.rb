
require 'test_helper'

class ThingTest < ActiveSupport::TestCase
  
  test "sets previous on the reply" do
    original = Factory :thing
    reply = Factory :thing
    reply.reply_to original.id
    assert_equal original, reply.previous
  end
  
  test "sets next on the original when replying" do
    original = Factory :thing
    reply = Factory :thing
    reply.reply_to original.id
    assert_equal reply, original.next    
  end
  
  test "saves the new thing without a previous if it's brand new" do
    thing = Factory :thing
    thing.reply_to nil
    assert_nil thing.previous
  end
end
