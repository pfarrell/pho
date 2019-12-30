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

    Thumb.mk_medthumb(photo.asset.path, "public/thumbnails#{path.dirname.to_s}/#{file_name}-medthumb.jpg")
    photo.asset.thumbnail_med = "thumbnails#{path.dirname.to_s}/#{file_name}-medthumb.jpg"
    photo.asset.save
  end

  def self.mk_medthumb(photo_path, dest_path)
    i = Magick::Image.read(photo_path).first
    FileUtils.mkdir_p(File.dirname(dest_path))
    i.resize_to_fill(400,400).write(dest_path)
  end

  def self.video_thumbnail(path, file_name, video)
    movie = FFMPEG::Movie.new(video.asset.path)
    temp_path = "/tmp/#{file_name}-thumb.jpg"
    movie.screenshot(temp_path, seek_time: 1)
    Thumb.mk_medthumb(temp_path, "public/thumbnails#{path.dirname.to_s}/#{file_name}-medthumb.jpg")
    video.asset.thumbnail_med = "thumbnails#{path.dirname.to_s}/#{file_name}-medthumb.jpg"
    video.asset.save
  end
end

assets = Asset.where(thumbnail_med: nil).map(&:id)
assets.each_with_index do |id, i|
  asset = Asset[id]
  path = Pathname.new(asset.path)
  file_name = path.basename
  #puts photo.path
  next if File.exist?(asset.thumbnail_med) unless asset.thumbnail_med.nil?

  begin
  if asset.type == 'photo'
    Thumb.photo_thumbnail(path, file_name, asset.photo)
  elsif asset.type == 'video'
    Thumb.video_thumbnail(path, file_name, asset.video)
  end
  rescue Exception => ex
    $stderr.puts("ERROR asset##{asset.id}: #{ex.message}")
  end
  if id % 10 == 0
    print '.'
    GC.start
  end
end
