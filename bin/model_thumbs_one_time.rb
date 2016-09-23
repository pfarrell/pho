require './app'
require 'rmagick'
require 'pathname'

class Thumb
  def self.thumbnail(photo)
    path = Pathname.new(photo.path)
    file_name = path.basename
    if File.exist?("public/thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg")
      photo.thumbnail = "thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg"
      photo.save
      print " =>  saved"
    end
  end
end

photos = Photo.all.map(&:id)
photos.each_with_index do |id, i|
  photo = Photo[id]
  print photo.path
  Thumb.thumbnail(photo)
  if id % 25 == 0
    print '.'
    GC.start
  end
  print "\n"
end
