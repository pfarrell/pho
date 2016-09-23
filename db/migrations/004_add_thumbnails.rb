Sequel.migration do
  change do
    alter_table(:photos) do
      add_column :thumbnail, String
    end
  end
end
