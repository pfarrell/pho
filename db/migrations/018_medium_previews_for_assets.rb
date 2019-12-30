Sequel.migration do
  change do
    alter_table(:assets) do
      add_column :thumbnail_med, String
    end
  end
end
