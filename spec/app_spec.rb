require 'spec_helper'

describe 'App' do

  let(:photo) { Photo.new.save }

  before do
    photo
  end

  def authenticate
    set_cookie "auth=#{Base64.encode64({test: 'hello'}.to_json)}"
  end

  context "authenticated" do
    before do
      authenticate
    end

    ["development", "production"].each do |env|
      it "changes the login location based on environment" do
        ENV["RACK_ENV"] = env
        get "/photos/recent/1"
        expect(last_response).to be_ok
      end
    end

    ["/", "/photos/recent"].each do |path|
      it "authenticates access and redirects #{path}" do
        get path
        expect(last_response).to be_redirect
      end
    end

    ["/photos/recent/1"].each do |path|
      it "authenticates access and redirects #{path}" do
        get path
        expect(last_response).to be_ok
      end
    end

    it "retrieves a page for each pictures" do
      get "/photo/#{photo.id}"
      expect(last_response).to be_ok
    end

    it "lets you hide photos" do
      expect(Photo[photo.id].hidden).to eq(false)
      put "/photo/#{photo.id}", {hidden: ""}
      expect(last_response).to be_ok
      expect(Photo[photo.id].hidden).to eq(true)
    end
  end
end
