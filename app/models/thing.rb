
class Thing < ActiveRecord::Base
  has_one :previous, :class_name => 'Thing'
  has_one :next, :class_name => 'Thing'
  
  validates_presence_of :title
  validates_presence_of :url, :if => Proc.new { |thing| thing.body.blank? } 
  validates_presence_of :body, :if => Proc.new { |thing| thing.url.blank? }
  
end