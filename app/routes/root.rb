class App < Sinatra::Application
  get "/" do
    if cookies[:auth] && validate_token(cookies[:auth])
      redirect url_for("/photos/recent")
    else
      haml :login
    end
    #redirect url_for("/photos/recent")
  end
end
