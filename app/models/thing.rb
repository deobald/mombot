
class Thing < ActiveRecord::Base
  has_one :next, :class_name => 'Thing', :foreign_key => 'previous_id'
  belongs_to :previous, :class_name => 'Thing'
  belongs_to :user, :class_name => 'User'
  
  validates_presence_of :user_id
  validates_presence_of :title
  validates_presence_of :url, :if => Proc.new { |thing| thing.body.blank? } 
  validates_presence_of :body, :if => Proc.new { |thing| thing.url.blank? }
  
  def reply_to original_id
    associate_to Thing.find(original_id) if valid original_id
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