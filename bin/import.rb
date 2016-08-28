require './app'
require 'exifr'
require 'digest'

class PhoIn
  def self.import_photo(file_path)
    image=EXIFR::JPEG.new(file_path)
    file = File.new(file_path)
    camera = create_camera(image.make, image.model)
    create_photo(image, camera, file)
  end

  def self.create_camera(make, model)
    Camera.find_or_create(make: make, model: model)
  end

  def self.create_photo(image, camera, file)  
    sha= Digest::SHA256.file(file)
    photo = Photo.find(hash: sha.hexdigest)
    if(photo.nil?) 
      photo = Photo.new(
        hash: sha.hexdigest, 
        path: File.realpath(file), 
        size: file.size, 
        date: image.date_time,
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
        longitude: image.exif&.gps&.longitude
      )
      photo.camera = camera
      photo.save
    end
    photo
  end
end

PhoIn.import_photo(ARGV[0])

