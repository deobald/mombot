require 'digest/sha1'

class User < ActiveRecord::Base
  include Authenticatable
  attr_protected :id, :salt, :admin
  
  has_many :votes
  has_many :pezez, :through => :votes
  
  validates_length_of :identity, :within => 3..40
  validates_length_of :password, :within => 4..40
  validates_confirmation_of :password
  validates_presence_of :identity, :email, :password, :password_confirmation, :salt
  validates_uniqueness_of :identity, :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"  
  
  def unvoted_candy
    Pez.all :include => :users, :conditions => { :status => 'seated', :users => { :id => nil }}
  end

end
