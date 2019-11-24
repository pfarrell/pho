class App < Sinatra::Application
  get "/" do
    redirect url_for("/photos/recent")
  end
end
