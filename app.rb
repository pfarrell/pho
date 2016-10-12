$: << File.expand_path('../app', __FILE__)

require 'sinatra'
require 'sinatra/url_for'
require 'sinatra/respond_to'
require 'sinatra/cookies'
require 'securerandom'
require 'haml'

class App < Sinatra::Application
  helpers Sinatra::UrlForHelper
  helpers Sinatra::Cookies
  register Sinatra::RespondTo

  enable :sessions
  set :session_secret, ENV["APP_SESSION_SECRET"] || "youshouldreallychangethis"
  set :views, Proc.new { File.join(root, "app/views") }

  helpers do

    def current_user
      cookie = request.cookies["auth"]
      cookie ? User.new(cookie) : nil
    end

    def login_location
      puts ENV["RACK_ENV"]
      case ENV["RACK_ENV"] || "development"
      when "development"
        "http://localhost:9292/application/2/login"
      when "production"
        "https://patf.net/moth/application/2/login"
      end
    end

    def protected(return_to=nil)
      url = return_to ? "#{login_location}?return_to=#{return_to}" : login_location
      redirect url unless current_user
    end

  end

  def page_seq(curr_page, page_count)
    start = curr_page > 5 ? curr_page - 5 : 1
    stop = page_count - curr_page > 5 ? curr_page + 5 : page_count
    return (start..stop)
  end

  before do
    response.set_cookie(:appc, value: SecureRandom.uuid, expires: Time.now + 3600 * 24 * 365 * 10) if request.cookies["bmc"].nil?
  end
end

require 'helpers'
require 'models'
require 'routes'
