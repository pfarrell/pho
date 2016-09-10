class App < Sinatra::Application
  get "/photos" do
  end

  get "/photos/recent" do
    redirect url_for("/photos/recent/1")
  end

  get "/photos/recent/:page" do
    page = params[:page].to_i
    haml :photos, locals: {base: "/photos/recent", photos: Photo.order(Sequel.desc(:date)).paginate(page, 100)}
  end

  get "/photo/:id" do
    haml :photo, locals: {photo: Photo[params[:id].to_i]}
  end
end
