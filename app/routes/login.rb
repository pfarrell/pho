class App < Sinatra::Application

  post "/login" do
    user = User.find(username: params[:username])
    raise Exception('user not found') if user.nil?
    begin
      user.check_password(params[:password])
    rescue
        haml :login
    end
    token = generate_token(user)
    respond_to do |f|
      f.json { {:token=>token}.to_json }
      f.html {
        cookies[:auth] = token
        destination = params[:return_to] || "/photos/recent"
        redirect url_for(destination)
      }
    end
  end
end
