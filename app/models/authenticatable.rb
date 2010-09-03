
module Authenticatable

  attr_accessor :password, :password_confirmation
  
  def self.included base
    base.extend ClassMethods
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
    self.salt = Secrets.random_string(10) if !self.salt?
    self.hashed_password = Secrets.encrypt(@password, self.salt)
  end

  def send_new_password
    new_pass = Secrets.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    Notifications.deliver_forgot_password(self.email, self.identity, new_pass)
  end

  module ClassMethods
    def authenticate(identity, pass)
      u = first(:conditions => ["identity = ?", identity])
      return nil if u.nil?
      return u if Secrets.encrypt(pass, u.salt) == u.hashed_password
      nil
    end
  end

end