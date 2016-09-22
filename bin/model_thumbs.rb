require './app'
require 'rmagick'
require 'pathname'

class Thumb
  def self.thumbnail(file)
    i = Magick::Image.read(file).first
    path = Pathname.new(file)
    FileUtils.mkdir_p("public/thumbnails/#{path.dirname.to_s}")
    file_name = path.basename
    i.resize_to_fill(100,100).write("public/thumbnails/#{path.dirname.to_s}/#{file_name}-thumb.jpg")
  end
end

photos = Photo.all.map(&:id)
photos.each_with_index do |id, i|
  photo = Photo[id]
  puts photo.path
  next if File.exist?(photo.thumbnail)
  Thumb.thumbnail(photo.path)
  if id % 25 == 0
    print '.'
    GC.start
  end
end
