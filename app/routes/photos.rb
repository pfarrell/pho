class App < Sinatra::Application
  before do
    @user = current_user(cookies[:auth])
  end

  get "/photos/recent" do
    protected
    redirect url_for("/photos/recent/1")
  end

  get "/photos/recent/photo/:id" do
    redirect url_for("/photo/#{params[:id]}")
  end

  get "/photos/recent/:page" do
    protected
    page = params[:page].to_i
    haml :photos, locals: {base: url_for("/photos/recent"), photos: Photo.order(Sequel.desc(:date)).paginate(page, 100), daterange: ""}
  end

  get "/photos/:page" do
    protected
    page = params[:page].to_i
    photos = Photo.search(params)
    haml :photos, locals: {
      base: url_for("/photos"),
      photos: photos.order(Sequel.desc(:date)).paginate(page, 100),
      daterange: params[:daterange],
    }
  end

  get "/photo/:id" do
    protected
    curr = Photo[params[:id].to_i]
    prev = Photo.where(Sequel.lit('date < ?', curr.date)).exclude(id: curr.id).order(:date, :id).last(3).reverse
    nxt = Photo.where(Sequel.lit('date > ?', curr.date)).exclude(id: curr.id).order(:date, :id).first(3)
    haml :photo, locals: {base: '', photo: curr, nxt: nxt, prev: prev, user_id: @user.id}.merge(symbolize_keys(params))
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
    favorite = Favorite.find_or_create(photo: photo, user_id: current_user.id.to_s)
    favorite.save.to_json
  end

  delete '/photo/:id/favorite' do
    protected
    photo = Photo[params[:id].to_i]
    favorite = Favorite.find(photo: photo, user_id: current_user.id)
    photo.remove_favorite(favorite)
    photo.to_json
  end

end
