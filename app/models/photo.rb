class Photo < Sequel::Model
  many_to_one  :camera
  one_to_one   :asset
  many_to_many :tags
  many_to_many :albums

  def file_name
    Pathname.new(self.asset.path).basename
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

end
