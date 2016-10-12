class App < Sinatra::Application
  get "/" do
    protected
    redirect url_for("/photos/recent")
  end
end
