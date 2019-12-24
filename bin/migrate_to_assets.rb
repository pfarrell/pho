require './app/db'
require './app/models/asset'

DB[:photos].all.each do |photo|
  asset = Asset.find_or_create(
    path: photo[:path],
    photo_id: photo[:id],
    type: 'photo',
    hash: photo[:hash],
    thumbnail: photo[:thumbnail],
    size: photo[:size],
    date: photo[:date],
    created_at: photo[:created_at],
    updated_at: photo[:updated_at]
  )
  update_ds = DB["UPDATE photos SET asset_id = ? WHERE id = ?", asset.id, photo[:id]]
  update_ds.update
  print '.'
end
