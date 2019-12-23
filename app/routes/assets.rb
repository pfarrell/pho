class App < Sinatra::Application
  before do
    @user = current_user(cookies[:auth])
  end

  get "/assets/recent" do
    protected
    redirect url_for("/assets/recent/1")
  end

  get "/assets/recent/asset/:id" do
    redirect url_for("/asset/#{params[:id]}")
  end

  get "/assets/recent/:page" do
    protected
    page = params[:page].to_i
    nxt = "#{page + 1}"
    prev = page > 1 ? "#{page - 1}" : nil
    navigation = {nxt: [nxt], prev: [prev]}
    assets = Asset.order(Sequel.desc(:date)).paginate(page, 100)
    haml :files, locals: {base: "/assets/recent", assets: assets, daterange: ""}.merge(navigation)
  end

  get "/assets/:page" do
    protected
    page = params[:page].to_i
    photos = Photo.search(params)
    haml :files, locals: {
      base: "",
      photos: photos.order(Sequel.desc(:date)).paginate(page, 100),
      daterange: params[:daterange],
    }
  end

  get "/asset/:id" do
    protected
    curr = Asset[params[:id].to_i]
    ids = DB.fetch("select q.* from (select lag(id, 3) over w lag_3, lag(id, 2) over w lag_2, lag(id, 1) over w lag_1, id, lead(id, 1) over w lead_1, lead(id, 2) over w lead_2, lead(id, 3) over w lead_3 from assets window w as (order by date, id desc)) q where id = #{curr.id}").first.values()
    ids = ids.reject{|x| x.nil?}
    assets = Asset.join(Sequel.lit("(values#{ids.each_with_index.map{|x,i| "(#{x}, #{i})"}.join(', ')}) as x (id, ordering) on assets.id = x.id order by x.ordering")).all
    mid = assets.find_index{|x| x.id == curr.id}
    prev = assets[0...mid]
    nxt = assets[mid+1..]
    if curr.type == 'photo'
      haml :photo, locals: {base: '', photo: curr.photo, nxt: nxt, prev: prev, user_id: @user.id}.merge(symbolize_keys(params))
    elsif curr.type == 'video'
      haml :video, locals: {base: '', video: curr.video, nxt: nxt, prev: prev, user_id: @user.id}.merge(symbolize_keys(params))
    end
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
    favorite = Favorite.find_or_create(photo: photo, user_id: @user.id.to_s)
    favorite.save.to_json
  end

  delete '/photo/:id/favorite' do
    protected
    photo = Photo[params[:id].to_i]
    favorite = Favorite.find(photo: photo, user_id: @user.id)
    photo.remove_favorite(favorite)
    photo.to_json
  end

end
