require './app'
require 'rmagick'
require 'pathname'

class Thumb
  def self.thumbnail(photo)
    i = Magick::Image.read(photo.asset.path).first
    path = Pathname.new(photo.asset.path)
    FileUtils.mkdir_p("public/thumbnails#{path.dirname.to_s}")
    file_name = path.basename
    i.resize_to_fill(100,100).write("public/thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg")
    photo.asset.thumbnail = "thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg"
    photo.asset.save
  end
end

assets = Asset.where(thumbnail: nil, type: 'photo').map(&:id)
assets.each_with_index do |id, i|
  asset = Asset[id]
  #puts photo.path
  next if File.exist?(asset.thumbnail) unless asset.thumbnail.nil?

  Thumb.thumbnail(asset.photo)
  if id % 10 == 0
    print '.'
    GC.start
  end
end
