
module Authenticatable

  attr_accessor :password, :password_confirmation
  
  def self.included base
    base.extend ClassMethods
    base.extend ProtectedClassMethods
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
    self.salt = self.class.random_string(10) if !self.salt?
    self.hashed_password = self.class.encrypt(@password, self.salt)
  end

  def send_new_password
    new_pass = self.class.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    Notifications.deliver_forgot_password(self.email, self.identity, new_pass)
  end

  module ClassMethods
    def authenticate(identity, pass)
      u = first(:conditions => ["identity = ?", identity])
      return nil if u.nil?
      return u if self.encrypt(pass, u.salt) == u.hashed_password
      nil
    end
  end

  protected

  module ProtectedClassMethods
    def encrypt(pass, salt)
      Digest::SHA1.hexdigest(pass+salt)
    end

    def random_string(len)
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      newpass = ""
      1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
      return newpass
    end
  end
  
end