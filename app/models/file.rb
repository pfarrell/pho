class PhotoFile < Sequel::Model
  one_to_one :photo
end
