Sequel.migration do
  change do
    alter_table(:photos) do
      add_column :hidden, TrueClass, default: false
    end
  end
end
