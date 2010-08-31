
class Pez < ActiveRecord::Base
  set_table_name 'pezez'
  
  def before_create
    self.priority = max_priority + 1
    self.status = 'waiting'
  end
  
  def max_priority
    Pez.maximum('priority') || 1
  end
end
