require './app'

Asset.where(type: 'photo').each do |asset|
  asset.orientation = asset.photo.orientation
  asset.hidden = asset.photo.hidden
  asset.save
end

