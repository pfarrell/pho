class App < Sinatra::Application

  get "/photos/recent" do
    redirect url_for("/photos/recent/1")
  end

  get "/photos/recent/:page" do
    page = params[:page].to_i
    haml :photos, locals: {base: "/photos/recent", photos: Photo.order(Sequel.desc(:date)).paginate(page, 100), daterange: ""}
  end

  get "/photos/:page" do
    page = params[:page].to_i
    photos = Photo.search(params)
    haml :photos, locals: {
      base: "/photos",
      photos: photos.order(Sequel.desc(:date)).paginate(page, 100),
      daterange: params[:daterange],
    }
  end

  get "/photo/:id" do
    curr = Photo[params[:id].to_i]
    prev = Photo.where(Sequel.lit('date < ?', curr.date)).order(Sequel.desc(:date)).first(3).reverse
    nxt = Photo.where(Sequel.lit('date > ?', curr.date)).order(:date).first(3)
    haml :photo, locals: {photo: curr, nxt: nxt, prev: prev, user_id: current_user.id}.merge(symbolize_keys(params))
  end

  put '/photo/:id' do
    photo = Photo[params[:id].to_i]
    photo.hidden = params.keys.include?('hidden')
    photo.save.to_json
  end

  post '/photo/:id/favorite' do
    photo = Photo[params[:id].to_i]
    favorite = Favorite.find_or_create(photo: photo, user_id: current_user.id)
    favorite.save.to_json
  end

  delete '/photo/:id/favorite' do
    photo = Photo[params[:id].to_i]
    favorite = Favorite.find(photo: photo, user_id: current_user.id)
    photo.remove_favorite(favorite)
    photo.to_json
  end

end
