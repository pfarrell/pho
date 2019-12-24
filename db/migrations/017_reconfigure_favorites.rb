Sequel.migration do
  change do
    drop_table(:favorites)
    create_table(:favorites) do
      primary_key :id
      Integer      :user_id
      Integer      :asset_id
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
