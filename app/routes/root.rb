class App < Sinatra::Application
  get "/" do
    haml :index, locals: {photos: Photo.all}
  end
end
