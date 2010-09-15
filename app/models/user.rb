require 'digest/sha1'
require "#{RAILS_ROOT}/lib/exceptions"

class User < ActiveRecord::Base
  include Authenticatable
  attr_accessor  :secret_code
  attr_protected :id, :salt, :admin, :adminify!
  
  has_many :votes
  has_many :pezez, :through => :votes
  has_many :things
  
  validates_length_of :identity, :within => 3..40
  validates_length_of :password, :within => 4..40
  validates_confirmation_of :password
  validates_presence_of :identity, :email, :password, :password_confirmation, :salt
  validates_uniqueness_of :identity, :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"  
  
  def self.admins
    admins = User.all(:conditions => ['admin = ?', true])
    return admins.size > 0 ? admins.map {|a| a.identity}.join(', ') : nil
  end
  
  def self.find_unvoted
    votable = Pez.votable
    User.all.inject([]) do |unvoted, user|
      unvoted << user unless votable.has_vote_from? user
      unvoted
    end
  end
  
  def self.find_lazies
    hours_passed = (Time.now - Pez.votable.created_at) / 1.hours
    hours_allowed = User.all.size * 8
    return [] unless hours_passed > hours_allowed
    find_unvoted
  end
  
  def before_create
    raise SecretCodeError unless secret_code_checks_out
    true
  end
  
  def after_create
    my_dispensed_pez.expire
  end
  
  def secret_code_checks_out
    my_dispensed_pez
  end
  
  def my_dispensed_pez
    Pez.first :conditions => ['status = ? AND identity = ? AND secret_code = ?', 'dispensed', identity, secret_code]
  end
  
  def dispenser
    Pez.all :conditions => { :status => 'seated' }
  end
  
  def pez
    Pez.first :conditions => ['identity = ?', self.identity]
  end
  
  def image_filename
    return '/images/what.png' unless self.pez.image
    self.pez.image.public_filename # boom.
  end
  
  def liked pez
    with_preference_for(pez) { |vote| vote.approve ? 'liked' : '' }
  end
  
  def disliked pez
    with_preference_for(pez) { |vote| vote.approve ? '' : 'disliked' }
  end
  
  def with_preference_for pez
    vote = Vote.for(pez, self)
    return '' unless vote
    yield vote
  end
  
end
