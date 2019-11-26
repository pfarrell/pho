Sequel.migration do
  change do
    create_table(:comments) do
      primary_key :id
      Integer      :photo_id
      Integer      :user_id
      String      :comment
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
