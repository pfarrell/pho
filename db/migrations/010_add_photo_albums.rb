Sequel.migration do
  change do
    create_table(:albums) do
      primary_key :id
      String      :user_id
      String      :name
      TrueClass   :public, default: true
      DateTime    :created_at
      DateTime    :updated_at
    end

    create_table(:albums_photos) do
      primary_key :id
      Integer     :album_id
      Integer     :photo_id
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
