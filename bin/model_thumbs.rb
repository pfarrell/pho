require './app'
require 'rmagick'
require 'pathname'
require 'streamio-ffmpeg'

class Thumb
  def self.photo_thumbnail(path, file_name, photo)
    path = Pathname.new(photo.asset.path)
    file_name = path.basename
    FileUtils.mkdir_p("public/thumbnails#{path.dirname.to_s}")
    file_name = path.basename

    Thumb.mk_thumb(photo.asset.path, "public/thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg")
    photo.asset.thumbnail = "thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg"
    photo.asset.save
  end

  def self.mk_thumb(photo_path, dest_path)
    i = Magick::Image.read(photo_path).first
    FileUtils.mkdir_p(File.dirname(dest_path))
    i.resize_to_fill(100,100).write(dest_path)
  end

  def self.video_thumbnail(path, file_name, video)
    movie = FFMPEG::Movie.new(video.asset.path)
    duration = (movie.duration / 2).floor
    temp_path = "/tmp/#{file_name}-thumb.jpg"
    movie.screenshot(temp_path, seek_time: duration)
    Thumb.mk_thumb(temp_path, "public/thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg")
    video.asset.thumbnail = "thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg"
    video.asset.save
  end
end

assets = Asset.where(thumbnail: nil).map(&:id)
assets.each_with_index do |id, i|
  asset = Asset[id]
  path = Pathname.new(asset.path)
  file_name = path.basename
  #puts photo.path
  next if File.exist?(asset.thumbnail) unless asset.thumbnail.nil?

  if asset.type == 'photo'
    Thumb.photo_thumbnail(path, file_name, asset.photo)
  elsif asset.type == 'video'
    Thumb.video_thumbnail(path, file_name, asset.video)
  end
  if id % 10 == 0
    print '.'
    GC.start
  end
end
