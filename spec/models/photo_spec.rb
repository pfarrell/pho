require 'spec_helper'

describe Photo do
  let(:photo) { Photo.new.save }

  context ".initialize" do
    it "initialize with hidden set to false" do
      expect(photo.hidden).to eq(false)
    end

    it "has a file_name" do
      photo.path = "/test/photo.jpg"
      photo.save
      expect(photo.file_name.to_s).to eq('photo.jpg')
    end
  end
end
