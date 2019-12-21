class App < Sinatra::Application
  before do
    @user = current_user(cookies[:auth])
  end

  get "/summary" do
    protected
    summary = Summary.all.each { |h|
      h[:year] = h[:year].to_i
      h[:link] = "/summary/#{h[:year].to_i}"
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
      h[:link]  = "/summary/#{params[:year]}/#{h[:month]}"
    }
    respond_to do |f|
      f.html { haml :summary, locals: {title: "Pics from #{params[:year]}", summary: summary, key: :month, breadcrumbs: [{'text': "#{params[:year]}", 'url': "/summary/#{params[:year]}", "active": true}]}}
      f.json { summary.to_json }
    end
  end

  get "/summary/:year/:month" do
    protected
    assets = Asset.by_month(params[:year], params[:month])
    respond_to do |f|
      f.html { haml :files, locals: {prev: [], nxt: [], base: "/summary/#{params[:year]}/#{params[:month]}", assets: assets, breadcrumbs: [{'text': "#{params[:year]}", 'url': "/summary/#{params[:year]}"}, {'text': "#{params[:month]}", 'url': "/summary/#{params[:year]}/#{params[:month]}", "active": true}]} }
      f.json { {year: params[:year], month: params[:month], assets: assets} }
    end
  end

  get "/summary/:year/:month/asset/:id" do
    protected
    curr = Asset[params[:id].to_i]
    ids = DB.fetch("select q.* from (select lag(id, 3) over w lag_3, lag(id, 2) over w lag_2, lag(id, 1) over w lag_1, id, lead(id, 1) over w lead_1, lead(id, 2) over w lead_2, lead(id, 3) over w lead_3 from assets window w as (order by date, id desc)) q where id = #{curr.id}").first.values()
    ids = ids.reject{|x| x.nil?}
    assets = Asset.join(Sequel.lit("(values#{ids.each_with_index.map{|x,i| "(#{x}, #{i})"}.join(', ')}) as x (id, ordering) on assets.id = x.id order by x.ordering")).all
    mid = assets.find_index{|x| x.id == curr.id}
    prev = assets[0...mid]
    nxt = assets[mid+1..]
    base = "/summary/#{params[:year]}/#{params[:month]}"
    breadcrumbs = [
      {'text': "#{params[:year]}", 'url': "/summary/#{params[:year]}"},
      {'text': "#{params[:month]}", 'url': "/summary/#{params[:year]}/#{params[:month]}", "active": true}
    ]

    if curr.type == 'photo'
      haml :photo, locals: {base: base, photo: curr.photo, nxt: nxt, prev: prev, breadcrumbs: breadcrumbs, user_id: @user.id}.merge(symbolize_keys(params))
    elsif curr.type == 'video'
      haml :video, locals: {base: base, video: curr.video, nxt: nxt, prev: prev, breadcrumbs: breadcrumbs,  user_id: @user.id}.merge(symbolize_keys(params))
    end
  end

  put '/summary/:year/:month/photo/:id' do
    protected
    photo = Photo[params[:id].to_i]
    photo.hidden = params.keys.include?('hidden')
    photo.save.to_json
  end

  post '/summary/:year/:month/photo/:id/favorite' do
    protected
    photo = Photo[params[:id].to_i]
    favorite = Favorite.find_or_create(photo: photo, user_id: @user.id.to_s)
    favorite.save.to_json
  end

  delete '/summary/:year/:month/photo/:id/favorite' do
    protected
    photo = Photo[params[:id].to_i]
    favorite = Favorite.find(photo: photo, user_id: @user.id)
    photo.remove_favorite(favorite)
    photo.to_json
  end
end

