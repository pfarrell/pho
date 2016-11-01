class Photo < Sequel::Model
  many_to_one  :camera
  one_to_one   :file
  many_to_many :tags
  one_to_many  :favorites

  def file_name
    Pathname.new(self.path).basename
  end

  def favorited?(user_id)
    Favorite.where(photo: self, user_id: user_id).count > 0
  end
end
