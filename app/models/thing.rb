
class Thing < ActiveRecord::Base
  has_one :next, :class_name => 'Thing', :foreign_key => 'previous_id'
  belongs_to :previous, :class_name => 'Thing'
  
  validates_presence_of :title
  validates_presence_of :url, :if => Proc.new { |thing| thing.body.blank? } 
  validates_presence_of :body, :if => Proc.new { |thing| thing.url.blank? }
  
  def reply_to original_id
    associate_to Thing.find(original_id) if original_id
    self.save!
  end
  
  def associate_to original
    self.previous = original
    original.next = self
    original.save!
  end
  
end