Sequel.migration do
  change do
    drop_table(:albums_photos)
    create_table(:albums_assets) do
      primary_key :id
      Integer     :album_id
      Integer     :asset_id
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end

