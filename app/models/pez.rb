
class Pez < ActiveRecord::Base
  set_table_name 'pezez'
  
  has_many :votes
  has_many :users, :through => :votes
  
  SEATED = 'seated'
  WAITING = 'waiting'
  DISPENSED = 'dispensed'
  
  def before_create
    self.priority = max_priority + 1
    wait_without_save
  end
  
  def max_priority
    Pez.maximum('priority') || 1
  end
  
  def votable?
    Pez.minimum('priority', :conditions => ["status = ?", SEATED]) == self.priority
  end
  
  def receive_vote_from user, approves
    vote = Vote.for(self, user)
    if vote
      vote.approve = approves
      vote.save!
    else
      Vote.create! :user => user, :pez => self, :approve => approves
    end
    dispense if votes_remaining == 0
  end
  
  def votes_so_far
    self.votes.count
  end
  
  def votes_remaining
    User.all.count - votes_so_far
  end
  
  def wait_without_save
    change_state_without_save 'waiting'
  end
  
  def wait
    change_state_to WAITING
  end
  
  def seat
    change_state_to SEATED
  end
  
  def dispense
    change_state_to DISPENSED
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
    self.status == WAITING
  end
  
  def seated?
    self.status == SEATED
  end
  
  def dispensed?
    self.status == DISPENSED
  end
end
