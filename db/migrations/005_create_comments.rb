Sequel.migration do
  change do
    create_table(:comments) do
      primary_key :id
      Fixnum      :photo_id
      Fixnum      :user_id
      String      :comment
      DateTime    :created_at
      DateTime    :updated_at
    end

    create_table(:users) do
      primary_key :id
      String      :username
      String      :email
      String      :password_hash
      String      :salt
      DateTime    :created_at
      DateTime    :updated_at
    end

  end
end
