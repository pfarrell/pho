Sequel.migration do
  change do
    create_table(:videos) do
      primary_key :id
      String      :path
      Integer     :camera_id
      String      :hash
      Integer     :size
      DateTime    :date
      String      :format
      String      :format_profile
      String      :duration
      Float       :latitude
      Float       :longitude
      Float       :altitude
      Float       :width
      Float       :height
      String      :aspect_ratio
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
