
class Pez < ActiveRecord::Base
  set_table_name 'pezez'
  
  has_many :votes
  has_many :users, :through => :votes
  has_one :image
  
  validates_uniqueness_of :identity
  
  SEATED = 'seated'
  WAITING = 'waiting'
  DISPENSED = 'dispensed'
  REJECTED = 'rejected'
  
  def self.new_with_colour options={}
    pez = Pez.new options
    pez.colour = '#' + Secrets.random_string(6)
    pez
  end
  
  def self.votable_priority
    Pez.minimum('priority', :conditions => ["status = ?", SEATED])
  end
  
  def self.votable
    Pez.first :conditions => ['priority = ?', votable_priority]
  end
  
  def before_create
    self.priority = max_priority + 1
    wait_without_save
  end
  
  def adminify!
    raise Exception.new("Sorry son.  Gotta be the first user to self-adminify.") if User.admins
    raise Exception.new("Sorry son.  Gotta be the first pez to self-adminify.") if Pez.all.size > 1
    dispense
    u = User.new
    u.identity = self.identity
    u.email = 'admin@admin.com'
    u.password = u.password_confirmation = 'admin'
    u.secret_code = self.secret_code
    u.save!
    u.adminify!
  end
  
  def max_priority
    Pez.maximum('priority') || 1
  end
  
  def votable?
    Pez.votable == self
  end
  
  def receive_vote_from user, approves
    vote = Vote.for(self, user)
    if vote
      vote.approve = approves
      vote.save!
    else
      Vote.create! :user => user, :pez => self, :approve => approves
    end
    pop_pop_pop
  end
  
  def pop_pop_pop
    return unless votes_remaining == 0
    loved_by_all? ? dispense : reject
  end
  
  def loved_by_all?
    self.votes.inject(true) {|loved, vote| loved && vote.approve }
  end
  
  def votes_so_far
    self.votes.count
  end
  
  def votes_remaining
    votes_required - votes_so_far
  end
  
  def votes_required
    User.all.size
  end
  
  def wait_without_save
    change_state_without_save WAITING
  end
  
  def wait
    change_state_to WAITING
  end
  
  def seat
    change_state_to SEATED
  end
  
  def dispense
    generate_secret_code
    change_state_to DISPENSED
  end
  
  def reject
    change_state_to REJECTED
  end
  
  def expire
    self.priority = 0
    self.save!
  end

  def change_state_without_save what
    self.status = what
  end
  
  def change_state_to what
    change_state_without_save what
    self.save!
    self    
  end
  
  def generate_secret_code
    self.secret_code = Secrets.random_string 16
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
  
  def rejected?
    self.status == REJECTED
  end
end
