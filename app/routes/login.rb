class App < Sinatra::Application

  post "/login" do
    user = User.find(username: params[:username])
    raise Exception('user not found') if user.nil?
    valid = user.check_password(params[:password])
    raise Exception('user not found') if !valid
    request.accept.each do |type|
      case type.to_s
      when '*/*'
        cookies[:auth] = generate_token(user)
        destination = params[:return_to] || "/photos/recent"
        halt redirect url_for(destination)
      end
    end
  end
end
