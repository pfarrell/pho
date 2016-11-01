Sequel.migration do
  change do
    create_table(:favorites) do
      primary_key :id
      String      :user_id
      Fixnum      :photo_id
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
