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
    photos = Photo.by_month(params[:year], params[:month])
    respond_to do |f|
      f.html { haml :photos, locals: { base: "/summary/#{params[:year]}/#{params[:month]}", photos: photos, breadcrumbs: [{'text': "#{params[:year]}", 'url': "/summary/#{params[:year]}"}, {'text': "#{params[:month]}", 'url': "/summary/#{params[:year]}/#{params[:month]}", "active": true}]} }
      f.json { {year: params[:year], month: params[:month], photos: photos} }
    end
  end

  get "/summary/:year/:month/photo/:id" do
    protected
    curr = Photo[params[:id].to_i]
    ids = DB.fetch("select q.* from (select lag(id, 3) over w lag_3, lag(id, 2) over w lag_2, lag(id, 1) over w lag_1, id, lead(id, 1) over w lead_1, lead(id, 2) over w lead_2, lead(id, 3) over w lead_3 from photos window w as (order by date, id desc)) q where id = #{curr.id}").first.values()
    ids = ids.reject{|x| x.nil?}
    photos = Photo.join(Sequel.lit("(values#{ids.each_with_index.map{|x,i| "(#{x}, #{i})"}.join(', ')}) as x (id, ordering) on photos.id = x.id order by x.ordering")).all
    mid = photos.find_index{|x| x.id == curr.id}
    prev = photos[0...mid]
    nxt = photos[mid+1..]
    haml :photo, locals: {base: "/summary/#{params[:year]}/#{params[:month]}", photo: curr, nxt: nxt, prev: prev, user_id: @user.id, breadcrumbs:[{'text': "#{params[:year]}", 'url': "/summary/#{params[:year]}"}, {'text': "#{params[:month]}", 'url': "/summary/#{params[:year]}/#{params[:month]}", "active": true}] }.merge(symbolize_keys(params))
  end
end

