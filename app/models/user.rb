require 'digest/sha1'

class User < ActiveRecord::Base
  validates_length_of :identity, :within => 3..40
  validates_length_of :password, :within => 5..40
  validates_confirmation_of :password
  validates_presence_of :identity, :email, :password, :password_confirmation, :salt
  validates_uniqueness_of :identity, :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"  

  attr_protected :id, :salt, :admin

  attr_accessor :password, :password_confirmation

  def self.authenticate(identity, pass)
    u = first(:conditions => ["identity = ?", identity])
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt) == u.hashed_password
    nil
  end
  
  def admin?
    self.admin
  end
  
  # i am lazy
  def adminify!
    @password = self.password_confirmation = 'whatever'
    self.admin = true
    self.save
  end

  def password=(pass)
    @password=pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  def send_new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    Notifications.deliver_forgot_password(self.email, self.identity, new_pass)
  end

  protected

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

end