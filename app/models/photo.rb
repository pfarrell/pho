class Photo < Sequel::Model
  include ::Resize
  many_to_one :camera
  one_to_one :file
  many_to_many :tags
  
  def file_name
    Pathname.new(self.path).basename
  end
  
  def thumbnail
    path = Pathname.new(self.path)
    "#{path.dirname}/#{file_name}-thumb.jpg"
  end
end
