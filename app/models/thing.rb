
class Thing < ActiveRecord::Base
  has_one :previous, :class_name => 'Thing', :foreign_key => 'next_id'
  belongs_to :next, :class_name => 'Thing'
  
  validates_presence_of :title
  validates_presence_of :url, :if => Proc.new { |thing| thing.body.blank? } 
  validates_presence_of :body, :if => Proc.new { |thing| thing.url.blank? }
  
  def reply_to original
    associate_to original if original
    self.save!
  end
  
  def associate_to original
    self.previous = original
    original.next = self
    original.save!
  end
  
end