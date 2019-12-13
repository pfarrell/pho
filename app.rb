$: << File.expand_path('../app', __FILE__)

require 'sinatra'
require 'sinatra/url_for'
require 'sinatra/respond_with'
require 'sinatra/cookies'
require 'securerandom'
require 'haml'
require 'uri'
require 'jwt'

class App < Sinatra::Application
  helpers Sinatra::UrlForHelper
  helpers Sinatra::Cookies
  register Sinatra::RespondWith

  enable :sessions
  set :session_secret, ENV["APP_SESSION_SECRET"] || "youshouldreallychangethis"
  set :views, Proc.new { File.join(root, "app/views") }

  helpers do

    def daterange
    end

    def symbolize_keys(my_hash)
      Hash[my_hash.map{|(k,v)| [k.to_sym,v]}]
    end

    def start_date
    end

    def end_date
    end

    def current_user()
      return @user
    end

    def current_user(token)
      @user = validate_token(token)
      return @user
    end

    def protected(return_to=nil)
      url = return_to ? url_for("/?return_to=#{return_to}") : url_for("/?return_to=#{request.url}")
      redirect url unless current_user(cookies[:auth])
    end

  end

  def page_seq(curr_page, page_count)
    start = curr_page > 5 ? curr_page - 5 : 1
    stop = page_count - curr_page > 5 ? curr_page + 5 : page_count
    return (start..stop)
  end

  def generate_token(user)
    exp = Time.now.to_i + 4 * 3600
    payload = { exp: exp, user_id: user.id }
    secret = ENV["AUTH_KEY"] || "my$ecretK3y"
    JWT.encode payload, secret, 'HS256'
  end

  def validate_token(token)
    begin
      secret = ENV["AUTH_KEY"] || "my$ecretK3y"
      decoded = JWT.decode(token, secret, true, { algorithm: 'HS256' })
      return User[decoded[0]['user_id']]
    rescue
      return nil
    end
  end
end

require 'models'
require 'routes'

require 'models/camera'
require 'models/asset'
require 'models/photo'
require 'models/tag'
require 'models/user'
require 'models/favorite'
require 'models/search'
require 'models/album'
require 'models/summary'
require 'models/video'

