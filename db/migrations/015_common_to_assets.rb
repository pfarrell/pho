Sequel.migration do
  change do
    alter_table(:assets) do
      add_column :hidden, TrueClass, default: false
      add_column :orientation, String
    end
  end
end
