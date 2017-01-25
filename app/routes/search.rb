class App < Sinatra::Application


  get "/search" do
    #create a search from daterange
    redirect url_for("/search/#{search.id}")
  end

  get "/search/:id" do
    #redirect to front page of search
  end

  get "/search/:id/:page" do
  end

end
