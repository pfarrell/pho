require './app'
require 'rmagick'
require 'pathname'
require 'byebug'

class Thumb
  def self.thumbnail(file)
    byebug
    i = Magick::Image.read(file).first
    file_name = Pathname.new(file).basename
    i.resize_to_fill(100,100).write("public/thumbnails/#{file_name}-thumb.jpg")
  end
end

image = ARGV
Thumb.thumbnail(image) unless image.empty?
