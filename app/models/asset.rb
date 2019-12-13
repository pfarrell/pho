class Asset < Sequel::Model
  one_to_one :photo
  one_to_one :video

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
