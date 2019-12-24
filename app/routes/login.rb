class App < Sinatra::Application

  post "/login" do
    begin
      user = User.find(username: params[:username])
      raise Exception('user not found') if user.nil?
      begin
        user.check_password(params[:password])
      rescue
        haml :login, locals: {error_message: 'Try again'}
      end
      token = generate_token(user)
      respond_to do |f|
        f.json { {:token=>token}.to_json }
        f.html {
          cookies[:auth] = token
          destination = params[:return_to] || "/rebecca"
          redirect url_for(destination)
        }
      end
    rescue
      haml :login, locals: {error_message: 'Try again'}
    end
  end
end
