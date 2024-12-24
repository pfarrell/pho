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
    Thumb.mk_medthumb(photo.asset.path, "public/thumbnails#{path.dirname.to_s}/#{file_name}-medthumb.jpg")
    photo.asset.thumbnail = "thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg"
    photo.asset.thumbnail_med = "thumbnails#{path.dirname.to_s}/#{file_name}-medthumb.jpg"
    photo.asset.save
  end

  def self.mk_thumb(photo_path, dest_path)
    i = Magick::Image.read(photo_path).first
    FileUtils.mkdir_p(File.dirname(dest_path))
    i.resize_to_fill(100,100).write(dest_path)
  end

  def self.mk_medthumb(photo_path, dest_path)
    i = Magick::Image.read(photo_path).first
    FileUtils.mkdir_p(File.dirname(dest_path))
    i.resize_to_fill(400,400).write(dest_path)
  end

  def self.mk_poster(video, photo_path, dest_path)
    i = Magick::Image.read(photo_path).first
    FileUtils.mkdir_p(File.dirname(dest_path))
    i.resize_to_fill(video.width,video.height).write(dest_path)
  end

  def self.video_thumbnail(path, file_name, video)
    movie = FFMPEG::Movie.new(video.asset.path)
    temp_path = "/tmp/#{file_name}-thumb.jpg"
    movie.screenshot(temp_path, seek_time: 1)
    Thumb.mk_thumb(temp_path, "public/thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg")
    Thumb.mk_medthumb(temp_path, "public/thumbnails#{path.dirname.to_s}/#{file_name}-medthumb.jpg")
    Thumb.mk_poster(video, temp_path, "public/thumbnails#{path.dirname.to_s}/#{file_name}-poster.jpg")
    # make a poster thumbnail here too
    video.asset.thumbnail = "thumbnails#{path.dirname.to_s}/#{file_name}-thumb.jpg"
    video.asset.thumbnail_med = "thumbnails#{path.dirname.to_s}/#{file_name}-medthumb.jpg"
    video.asset.poster = "thumbnails#{path.dirname.to_s}/#{file_name}-poster.jpg"
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

  begin
    if ['photo', 'live_photo'].include?(asset.type)
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
