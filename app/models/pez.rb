
class Pez < ActiveRecord::Base
  set_table_name 'pezez'
  
  def before_create
    self.priority = max_priority + 1
    wait_without_save
  end
  
  def max_priority
    Pez.maximum('priority') || 1
  end
  
  def wait_without_save
    self.status = 'waiting'
  end
  
  def wait
    wait_without_save
    self.save!
  end
  
  def seat
    self.status = 'seated'
    self.save!
  end
  
  def waiting?
    self.status == 'waiting'
  end
  
  def seated?
    self.status == 'seated'
  end
end
