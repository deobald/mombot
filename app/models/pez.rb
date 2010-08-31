
class Pez < ActiveRecord::Base
  set_table_name 'pezez'
  
  has_many :votes
  has_many :users, :through => :votes
  
  def before_create
    self.priority = max_priority + 1
    wait_without_save
  end
  
  def max_priority
    Pez.maximum('priority') || 1
  end
  
  def wait_without_save
    change_state_without_save 'waiting'
  end
  
  def wait
    change_state_to 'waiting'
  end
  
  def seat
    change_state_to 'seated'
  end
  
  def dispense
    change_state_to 'dispensed'
  end

  def change_state_without_save what
    self.status = what
  end
  
  def change_state_to what
    change_state_without_save what
    self.save!
    self    
  end
  
  def waiting?
    self.status == 'waiting'
  end
  
  def seated?
    self.status == 'seated'
  end
  
  def dispensed?
    self.status == 'dispensed'
  end
end
