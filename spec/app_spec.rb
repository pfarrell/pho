require 'spec_helper'

describe 'App' do

  def authenticate
    set_cookie "auth=#{Base64.encode64({test: 'hello'}.to_json)}"
  end

  ["/"].each do |path|
    it "authenticates access and redirects #{path}" do
      authenticate
      get "/"
      expect(last_response).to be_redirect
    end
  end

  ["/photos/recent"].each do |path|
    it "authenticates access to #{path}" do
      authenticate
      get "/"
      expect(last_response).to be_redirect
    end
  end

end
