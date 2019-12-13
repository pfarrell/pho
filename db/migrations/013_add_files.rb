Sequel.migration do
  change do
    create_table(:assets) do
      primary_key :id
      String      :path
      Integer     :photo_id
      Integer     :video_id
      String      :type
      String      :hash
      String      :thumbnail
      Integer     :size
      DateTime    :date
      DateTime    :created_at
      DateTime    :updated_at
    end

    alter_table(:photos) do
       add_column :asset_id, Integer
    end

    alter_table(:videos) do
       add_column :asset_id, Integer
    end
  end
end
