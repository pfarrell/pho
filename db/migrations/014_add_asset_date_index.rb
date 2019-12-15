Sequel.migration do
  change do
    alter_table(:assets) do
      add_index :date
    end
  end
end
