class App < Sinatra::Application
  get '/albums' do
    redirect url_for('/albums/1')
  end

  get '/album/:id' do
    redirect url_for("/album/#{params[:id]}/1")
  end

  get "/album/:id/:page" do
    page = params[:page].to_i
    album = Album[params[:id]]
    photos = Photo.where(albums: [album]).paginate(page, 100)
    haml :photos, locals: { base: "/album/#{params[:id]}", photos: photos}
  end

  get '/albums/:page' do
    require 'byebug'
    page = params[:page].to_i
    albums = Album.where(user_id: current_user.id).order(:name).paginate(page, 50)
    haml :albums, locals: { albums: albums }
  end

  post '/albums' do
    album = Album.create(name: params[:name], user_id: current_user.id)
    redirect("/album/#{album.id}")
  end
end
