Sequel.migration do
  change do
    alter_table(:photos) do
      add_column :orientation, Fixnum
    end
  end
end
