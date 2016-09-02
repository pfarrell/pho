module Resize

  def thumbnail_size(width=self.width, height=self.height, opts={})
    max = opts[:factor] || 200
    return [width, height] if width < max || height < max
    thumbnail_size(width/2, height/2, opts)
  end

end
