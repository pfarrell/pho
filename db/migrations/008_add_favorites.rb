Sequel.migration do
  change do
    create_table(:favorites) do
      primary_key :id
      Integer      :user_id
      Integer      :photo_id
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
