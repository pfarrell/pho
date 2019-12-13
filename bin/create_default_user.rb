require './app'

user = User.new(username: 'pfarrell')
user.set_password('pass')
user.save
