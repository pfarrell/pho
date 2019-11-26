Sequel.migration do
  change do
    create_table(:tags) do
      primary_key :id
      String      :tag
      DateTime    :created_at
      DateTime    :updated_at
    end

    create_table(:photos_tags) do
      primary_key :id
      Integer      :photo_id
      Integer      :tag_id
      DateTime    :created_at
      DateTime    :updated_at
    end

  end
end
