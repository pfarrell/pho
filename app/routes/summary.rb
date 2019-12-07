class App < Sinatra::Application
  before do
    @user = current_user(cookies[:auth])
  end

  get "/summary" do
    protected
    summary = Summary.all.each { |h|
      h[:year] = h[:year].to_i
      h[:link] = url_for("/summary/#{h[:year].to_i}")
    }
    respond_to do |f|
      f.html { haml :summary, locals: {title:'Pics By Year', summary: summary, key: :year}}
      f.json { summary.to_json }
    end
  end

  get "/summary/:year" do
    protected
    summary = Summary.by_year(params[:year]).each { |h|
      h[:month] = h[:month].to_i
      h[:link]  = url_for("/summary/#{params[:year]}/#{h[:month]}")
    }
    respond_to do |f|
      f.html { haml :summary, locals: {title: "Pics from #{params[:year]}", summary: summary, key: :month, breadcrumbs: [{'text': "#{params[:year]}", 'url': url_for("/summary/#{params[:year]}"), "active": true}]}}
      f.json { summary.to_json }
    end
  end

  get "/summary/:year/:month" do
    protected
    photos = Photo.by_month(params[:year], params[:month])
    respond_to do |f|
      f.html { haml :photos, locals: { base: url_for("/summary/#{params[:year]}/#{params[:month]}"), photos: photos, breadcrumbs: [{'text': "#{params[:year]}", 'url': url_for("/summary/#{params[:year]}")}, {'text': "#{params[:month]}", 'url': url_for("/summary/#{params[:year]}/#{params[:month]}"), "active": true}]} }
      f.json { {year: params[:year], month: params[:month], photos: photos} }
    end
  end

  get "/summary/:year/:month/photo/:id" do
    protected
    curr = Photo[params[:id].to_i]
    prev = Photo.where(Sequel.lit('date < ?', curr.date)).exclude(id: curr.id).order(:date, :id).last(3).reverse
    nxt = Photo.where(Sequel.lit('date > ?', curr.date)).exclude(id: curr.id).order(:date, :id).first(3)
    haml :photo, locals: {base: url_for("/summary/#{params[:year]}/#{params[:month]}"), photo: curr, nxt: nxt, prev: prev, user_id: @user.id}.merge(symbolize_keys(params))
  end
end

