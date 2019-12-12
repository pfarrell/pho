Sequel.migration do
  change do
    create_table(:photos) do
      primary_key :id
      Integer     :camera_id
      Float       :exposure_time
      Float       :f_stop
      Float       :iso_speed
      Float       :shutter_speed
      Float       :aperture
      Float       :brightness
      Float       :focal_length
      Boolean     :flash
      Float       :x_resolution
      Float       :y_resolution
      Float       :latitude
      Float       :longitude
      Float       :direction
      Float       :altitude
      Float       :width
      Float       :height
      DateTime    :created_at
      DateTime    :updated_at
    end

    create_table(:cameras) do
      primary_key :id
      String      :make
      String      :model
      DateTime    :created_at
      DateTime    :updated_at
    end

  end
end
