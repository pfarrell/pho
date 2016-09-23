require './app'
require 'rmagick'
require 'pathname'

class Thumb
  def self.thumbnail(photo)
    i = Magick::Image.read(photo.path).first
    path = Pathname.new(photo.path)
    FileUtils.mkdir_p("public/thumbnails#{path.dirname.to_s}")
    file_name = path.basename
    i.resize_to_fill(100,100).write("public/thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg")
    photo.thumbnail = "thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg"
    photo.save
  end
end

photos = Photo.all.map(&:id)
photos.each_with_index do |id, i|
  photo = Photo[id]
  puts photo.path
  next if File.exist?(photo.thumbnail) unless photo.thumbnail.nil?

  Thumb.thumbnail(photo)
  if id % 25 == 0
    print '.'
    GC.start
  end
end
