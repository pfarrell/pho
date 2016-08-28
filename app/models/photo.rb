class Photo < Sequel::Model
  many_to_one :camera
  one_to_one :file
end
