require './app'
require 'rmagick'
require 'pathname'
require 'byebug'

Photo.all.each do |photo|
  puts photo.path
  image = Magick::Image.read(photo.path).first
  p=EXIFR::JPEG.new(photo.path)
  photo.orientation = image.orientation&.to_i || p.exif&.orientation&.to_i
  photo.save
end

#class Thumb
#  def self.thumbnail(file)
#    i = Magick::Image.read(file).first
#    file_name = Pathname.new(file).basename
#    i.resize_to_fill(100,100).write("public/thumbnails/#{file_name}-thumb.jpg")
#  end
#end

#image = ARGV[0]
#Thumb.thumbnail(image) unless image.empty?
