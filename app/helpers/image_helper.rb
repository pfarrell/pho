module Resize

  def thumbnail_size(width=self.width, height=self.height, opts={})
    max = opts[:factor] || 200
    return [width, height] if width < max || height < max
    thumbnail_size(width/2, height/2, opts)
  end

  def create_thumbnail
    img = Magick::Image::read(File.new("public/#{self.thumbnail}"))
    img.first.resize_to_fill(75,75).write("/tmp/test.jpg")

  end

end
