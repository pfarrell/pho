class Album < Sequel::Model
  many_to_many :assets
  one_to_many :user
end
