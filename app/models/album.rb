class Album < Sequel::Model
  many_to_many :assets
end
