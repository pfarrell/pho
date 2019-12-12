class Pfile < Sequel::Model
  one_to_one :photo
  one_to_one :video

  def self.by_month(year, month)
    Pfile.where(Sequel.function(:date_part, 'year', :date) => year)
      .where(Sequel.function(:date_part, 'month', :date) => month)
      .order(:date)
  end
end
