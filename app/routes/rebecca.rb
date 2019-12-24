require 'byebug'
class App < Sinatra::Application

  get "/rebecca" do
    redirect url_for("/rebecca/1")
  end

  get "/rebecca/:page" do
    haml "bec#{params[:page]}".to_sym, layout: :welcome_layout
  end
end
