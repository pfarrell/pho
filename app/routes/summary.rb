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
      f.html { haml :summary, locals: {summary: summary, key: :year}}
      f.json { summary.to_json }
    end
  end

  get "/summary/:year" do
    protected
    summary = Summary.by_year(params[:year]).each { |h|
      h[:month] = h[:month].to_i,
      h[:link]  = url_for("/summary/#{params[:key]}/#{h[:month]}")
    }
    respond_to do |f|
      f.html { haml :summary, locals: {summary: summary, key: :month}}
      f.json { summary.to_json }
    end
  end
end
