
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
    thing.title = 'free beans!'
    thing.reply_to nil
    thing.reload
    assert_nil thing.previous
    assert_equal 'free beans!', thing.title
  end
  
  test "saves the new thing without a previous if it receives an empty string" do
    thing = Factory :thing
    thing.reply_to ""
    assert_nil thing.previous
  end
  
  test "replying locks out replies on the original" do
    original = Factory :thing
    reply = Factory :thing
    reply.reply_to original.id
    second_reply = Factory :thing
    assert_raise(Exception) { reply.reply_to original.id }
  end
  
  test "finds all things in a thread" do
    not_in_thread = Factory :thing
    original = Factory :thing
    reply = Factory :thing
    reply.reply_to original.id
    reply_on_reply = Factory :thing
    reply_on_reply.reply_to reply
    assert_equal [original, reply, reply_on_reply], Thing.thread_for(original.id)
  end
  
  test "finds a thread for the non-head by finding the head" do
    original = Factory :thing
    reply = Factory :thing
    reply.reply_to original.id
    assert_equal [original, reply], Thing.thread_for(reply)
  end
  
end
