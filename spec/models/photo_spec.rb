require 'spec_helper'

describe Photo do
  context ".initialize" do
    it "initialize with hidden set to false" do
      expect(Photo.new.save.hidden).to eq(false)
    end

    it "has a file_name" do
      photo = Photo.new(path: "/test/photo.jpg").save
      expect(photo.file_name.to_s).to eq('photo.jpg')
    end
  end
end
