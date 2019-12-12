Sequel.migration do
  change do
    alter_table(:photos) do
      add_index :camera_id
    end
  end
end
