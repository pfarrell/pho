class Photo < Sequel::Model
  many_to_one  :camera
  one_to_one   :file
  many_to_many :tags
  one_to_many  :favorites

  def file_name
    Pathname.new(self.path).basename
  end

  def favorited?(user_id)
    Favorite.where(photo: self, user_id: user_id).count > 0
  end

  def self.search(query)
    photos = apply_params(Photo, query)
    require 'byebug'
    byebug
    photos
  end

  def self.apply_params(klass, query)
    klass = klass.daterange(query[:daterange]) if query[:daterange]
    klass
  end

  def self.daterange(range)
    start, stop = range.split('/')
    where{date >= start}.where{date <= stop}
  end
end
