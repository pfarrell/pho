class App < Sinatra::Application

  get "/photos" do
  end

  get "/photos/recent" do
    redirect url_for("/photos/recent/1")
  end

  get "/photos/recent/:page" do
    protected
    page = params[:page].to_i
    haml :photos, locals: {base: "/photos/recent", photos: Photo.order(Sequel.desc(:date)).paginate(page, 100)}
  end

  get "/photo/:id" do
    protected
    curr = Photo[params[:id].to_i]
    prev = Photo.where('date < ?', curr.date).order(Sequel.desc(:date)).first(3).reverse
    nxt = Photo.where('date > ?', curr.date).order(:date).first(3)
    haml :photo, locals: {photo: curr, nxt: nxt, prev: prev, user_id: current_user.id}
  end

  put '/photo/:id' do
    protected
    photo = Photo[params[:id].to_i]
    photo.hidden = params.keys.include?('hidden')
    photo.save.to_json
  end

  post '/photo/:id/favorite' do
    protected
    photo = Photo[params[:id].to_i]
    favorite = Favorite.find_or_create(photo: photo, user_id: current_user.id)
    favorite.save.to_json
  end

  delete '/photo/:id/favorite' do
    require 'byebug'
    byebug
    protected
    photo = Photo[params[:id].to_i]
    favorite = Favorite.find(photo: photo, user_id: current_user.id)
    photo.remove_favorite(favorite)
    photo.to_json
  end

end
