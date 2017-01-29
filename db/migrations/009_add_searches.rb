Sequel.migration do
  change do
    create_table(:searches) do
      primary_key :id
      String      :daterange
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
