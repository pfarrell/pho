require './app'
require 'exifr'
require 'exifr/jpeg'
require 'rmagick'
require 'digest'
require 'json'
require 'mediainfo'

class PhoIn
  def self.import_photo(file_path, tags)
    image=EXIFR::JPEG.new(file_path)
    magick = Magick::Image.read(file_path).first
    tags = create_tags(tags)
    file = File.new(file_path)
    camera = create_camera(image.make, image.model)
    create_photo(magick, image, camera, file, tags)
  end

  def self.import_video(file_path, tags)
    file = File.new(file_path)
    info = MediaInfo.from(file_path)
    camera = info.general.extra.respond_to?(:make) ? create_camera(info.general.extra.make, info.general.extra.model) : nil
    create_video(file, info, camera, tags)
  end

  def self.create_tags(json)
    return [] if json.nil?
    ret = []
    tags = JSON.parse(json)
    tags.each{|k,v| ret << Tag.find_or_create(tag: v)}
    ret
  end

  def self.create_camera(make, model)
    Camera.find_or_create(make: make, model: model)
  end

  def self.numberify(str)
    return 0 if str.nil?
    return str unless str.kind_of?(String)
    if str.to_s.match(/pixels/)
      return str.to_s.gsub('pixels', '').gsub(' ', '').to_i
    end
    str.to_s
  end

  def self.create_photo(magick, image, camera, file, tags)
    sha= Digest::SHA256.file(file)
    asset = Asset.find(hash: sha.hexdigest)
    if(asset.nil?)
      puts "--> #{file.path}"
      asset = Asset.find_or_create(
        type: 'photo',
        hash: sha.hexdigest,
        path: File.realpath(file),
        size: file.size,
        date: image.date_time_original || image.date_time_digitized || image.date_time || file.ctime,
        orientation: magick.orientation&.to_i&.to_s || image.exif&.orientation&.to_id&.to_s,
      )
      photo = Photo.new(
        exposure_time: image.exif&.exposure_time,
        f_stop: image.exif&.f_number,
        iso_speed: image.iso_speed_ratings,
        shutter_speed: image.shutter_speed_value,
        aperture: image.aperture_value,
        brightness: image.brightness_value,
        focal_length: image.focal_length,
        flash: (image.flash == 1),
        x_resolution: image.x_resolution,
        y_resolution: image.y_resolution,
        direction: image.gps_img_direction,
        altitude: image.gps_altitude,
        width: image.width,
        height: image.height,
        latitude: image.exif&.gps&.latitude,
        longitude: image.exif&.gps&.longitude,
      )
      photo.save
      photo.camera = camera
      photo.asset = asset
      asset.photo = photo
      asset.save
      tags.each do |tag|
        photo.add_tag tag
      end
      photo.save
    else
      puts "#{file.path} already loaded"
    end
    photo
  end

  def self.parse_gps(info)
    gps = nil
    gps = info&.general&.extra&.xyz if info.general.extra.respond_to?(:xyz)
    gps ||=info&.general&.extra&.com_apple_quicktime_location_iso6709
    if gps
      gps.split(/(?=[+-])/).each{|x| x.gsub!(/[\+\/]/, '')}
    end
  end

  def self.create_video(file, info, camera, tags)
    sha = Digest::SHA256.hexdigest(YAML.dump(info))
    asset = Asset.find(hash: sha)
    if(asset.nil?)
      puts "--> #{file.path}"
      asset = Asset.find_or_create(
        type: 'video',
        hash: sha,
        path: File.realpath(file),
        size: file.size,
        date: info&.general&.comapplequicktimecreationdate || info&.general&.recorded_date || info&.general&.encoded_date || file.ctime,
      )
      video = Video.new(
        format: info.general&.format,
        format_profile: info.general&.format_profile,
        duration: info.general&.duration,
        width: numberify(info.video&.width),
        height: numberify(info.video&.height),
        aspect_ratio: info.video&.displayaspectratio&.to_r&.rationalize(0.05)&.to_s&.gsub('/', ':')
      )
      gps = parse_gps(info)
      if gps
        video.latitude = gps[0]
        video.longitude = gps[1]
        video.altitude  = gps[2]
      end

      video.save
      if camera
        video.camera = camera
      end
      video.asset = asset
      asset.video = video
      asset.save
      tags = create_tags(tags)
      tags.each do |tag|
        video.add_tag tag
      end
      video.save
    else
      puts "#{file.path} already loaded"
    end
    video
  end
end

file, tags = ARGV
if file.downcase.end_with?(".jpg") || file.downcase.end_with?(".jpeg")
  PhoIn.import_photo(file, tags)
else
  PhoIn.import_video(file, tags)
end
