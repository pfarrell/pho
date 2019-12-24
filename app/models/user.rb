require 'bcrypt'

class User < Sequel::Model
  one_to_many :albums

  def set_password(pw)
    self.password = BCrypt::Password.create(pw)
  end

  def check_password(pw)
    password = BCrypt::Password.new(self.password)
    return password == pw
  end

  def name
    "#{self.username}"
  end
end
