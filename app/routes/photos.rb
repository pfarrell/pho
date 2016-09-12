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

  def proximate(start, direction)
    ret = start
    loop do 
      if direction == 'up'
        ret += 1
      else
        ret -= 1
      end
      return ret if Photo[ret]
    end
  end

  get "/photo/:id" do
    nxt = proximate(params[:id].to_i, 'up')
    prev = proximate(params[:id].to_i, 'down')
    haml :photo, locals: {photo: Photo[params[:id].to_i], nxt: nxt, prev: prev}
  end
end
