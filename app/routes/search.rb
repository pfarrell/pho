class App < Sinatra::Application


  get "/search" do
    search = Search.create(daterange: params[:daterange])
    redirect url_for("/search/#{search.id}")
  end

  get "/search/:id" do
    search = Search[params[:id].to_i]
    redirect url_for("/search/#{search.id}/1")
  end

  get "/search/:id/:page" do
    search = Search[params[:id].to_i]
    page = params[:page].to_i
    photos = Photo.where(Sequel.lit('date between ? and ?', search.start_date, search.end_date))
                  .order(:date)
                  .paginate(page, 100)
    haml :files, locals: { base: url_for("/search/#{params[:id]}"), photos: photos, daterange: search.daterange }
  end

end
