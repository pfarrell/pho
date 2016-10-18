class App < Sinatra::Application

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

  get "/photos" do
  end

  get "/photos/recent" do
    redirect url_for("/photos/recent/1")
  end

  get "/photos/recent/:page" do
    protected(request.fullpath)
    page = params[:page].to_i
    haml :photos, locals: {base: "/photos/recent", photos: Photo.order(Sequel.desc(:date)).paginate(page, 100)}
  end

  get "/photo/:id" do
    protected(request.fullpath)
    curr = Photo[params[:id].to_i]
    prev = Photo.where('date < ?', curr.date).order(Sequel.desc(:date)).first
    nxt = Photo.where('date > ?', curr.date).order(:date).first
    haml :photo, locals: {photo: curr, nxt: nxt, prev: prev}
  end

  put '/photo/:id' do
    protected
    photo = Photo[params[:id].to_i]
    photo.hidden = params.keys.include?('hidden')
    photo.save.to_json
  end
end
