class User
  attr_accessor :name, :token

  def initialize(token)
    require 'byebug'
    byebug
    return {} if token.nil?
    hsh = JSON.parse(Base64.decode64(token), symbolize_names: true) unless token.nil?
  end

end
