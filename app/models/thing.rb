
class Thing < ActiveRecord::Base
  has_one :next, :class_name => 'Thing', :foreign_key => 'previous_id'
  belongs_to :previous, :class_name => 'Thing'
  belongs_to :user, :class_name => 'User'
  
  validates_presence_of :user_id
  validates_presence_of :title
  validates_presence_of :url, :if => Proc.new { |thing| thing.body.blank? } 
  validates_presence_of :body, :if => Proc.new { |thing| thing.url.blank? }
  
  def self.thread_for id
    thread = []
    thing = Thing.find(id).first_in_thread
    thread << thing
    while thing.next do
      thing = thing.next
      thread << thing
    end
    thread
  end
  
  def first_in_thread
    before = self
    while before.previous do
      before = before.previous
    end
    before
  end
  
  def reply_to original_id
    if valid original_id
      original = Thing.find original_id
      raise Exception.new("Can't reply to a thing that already has a reply.") if original.next
      associate_to original
    end
    self.save!
  end
  
  def valid id
    id && id != ""
  end
  
  def associate_to original
    self.previous = original
    original.next = self
    original.save!
  end
  
end