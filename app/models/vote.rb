
class Vote < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :pez
  
  validates_uniqueness_of :user_id, :scope => :pez_id
  
  def self.for pez, user
    Vote.all(:conditions => { :pez_id => pez, :user_id => user }).first
  end
  
end