class App < Sinatra::Application
  get "/" do
    if cookies[:auth] && validate_token(cookies[:auth])
      redirect url_for("/summary")
    else
      haml :login, layout: :welcome_layout
    end
  end

  get "/logout" do
    response.delete_cookie(:auth)
    redirect url_for("/")
  end
end
