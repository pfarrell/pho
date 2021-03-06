class Video < Sequel::Model
  many_to_one  :camera
  one_to_one   :asset
  many_to_many :tags
  one_to_many  :favorites
  many_to_many :albums

  def file_name
    Pathname.new(self.path).basename
  end

  def favorited?(user_id)
    Favorite.where(photo: self, user_id: user_id.to_s).count > 0
  end

  def self.search(query)
    apply_params(Photo, query)
  end

  def self.apply_params(klass, query)
    klass = klass.daterange(query[:daterange]) if query[:daterange]
    klass
  end

  def self.daterange(range)
    start, stop = range.split('/')
    where{date >= start}.where{date <= stop} unless start == nil
  end

  def self.by_month(year, month)
    Video.where(Sequel.function(:date_part, 'year', :date) => year)
      .where(Sequel.function(:date_part, 'month', :date) => month)
      .order(:date)
  end
end
