class Asset < Sequel::Model
  one_to_one :photo
  one_to_one :video
  many_to_many :albums
  one_to_many :user
  one_to_many  :favorites

  def favorited?(user_id)
    Favorite.where(asset: self, user_id: user_id).count > 0
  end

  def self.by_month(year, month)
    Asset.where(Sequel.function(:date_part, 'year', :date) => year)
      .where(Sequel.function(:date_part, 'month', :date) => month)
      .order(:date)
  end

  def self.photos()
    Asset.where(type: 'photo')
  end

  def self.videos()
    Asset.where(type: 'video')
  end
end
