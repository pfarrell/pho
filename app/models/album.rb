class Album < Sequel::Model
  many_to_many :photos
end
