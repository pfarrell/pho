Sequel.migration do
  change do
    alter_table(:assets) do
      add_column :poster, String
    end
  end
end
