require './app'
require 'rmagick'
require 'pathname'

class Thumb
  def self.thumbnail(photo)
    i = Magick::Image.read(photo.pfile.path).first
    path = Pathname.new(photo.pfile.path)
    FileUtils.mkdir_p("public/thumbnails#{path.dirname.to_s}")
    file_name = path.basename
    i.resize_to_fill(100,100).write("public/thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg")
    photo.pfile.thumbnail = "thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg"
    photo.pfile.save
  end
end

pfiles = Pfile.where(thumbnail: nil).map(&:id)
pfiles.each_with_index do |id, i|
  pfile= Pfile[id]
  #puts photo.path
  next if File.exist?(pfile.thumbnail) unless pfile.thumbnail.nil?

  Thumb.thumbnail(pfile.photo)
  if id % 25 == 0
    print '.'
    GC.start
  end
end
