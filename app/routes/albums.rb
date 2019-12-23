class App < Sinatra::Application
  before do
    @user = current_user(cookies[:auth])
  end

  get '/albums' do
    redirect url_for('/albums/1')
  end

  get '/album/:id' do
    album = Album[params[:id]]
    haml :files, locals: {prev: [], nxt: [], base: "#{url_for("/album/#{params[:id]}")}", assets: album.assets }
  end

  get '/albums/:page' do
    page = params[:page].to_i
    albums = Album.where(user_id: @user.id).order(:name).paginate(page, 50)
    haml :albums, locals: { albums: albums }
  end

  post '/albums' do
    album = Album.create(name: params[:name], user_id: @user.id)
    redirect("/album/#{album.id}")
  end
end
