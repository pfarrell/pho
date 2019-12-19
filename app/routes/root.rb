class App < Sinatra::Application
  get "/" do
    if cookies[:auth] && validate_token(cookies[:auth])
      redirect url_for("/assets/recent")
    else
      haml :login
    end
  end

  get "/logout" do
    response.delete_cookie(:auth)
    redirect url_for("/")
  end
end
