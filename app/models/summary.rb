class Summary
  def self.all
    DB[:photos]
      .group_and_count(Sequel.as(Sequel.function(:date_part, 'year', :date), 'year'))
      .order(Sequel.desc(:year))
      .all
  end

  def self.by_year(year)
    DB[:photos]
      .where(Sequel.function(:date_part, 'year', :date) => year)
      .group_and_count(Sequel.as(Sequel.function(:date_part, 'month', :date), 'month'))
      .order(:month)
      .all
  end

  def self.month_counts()
    Photo.group_and_count(Sequel.as(Sequel.function(:to_char, :date, 'YYYY-MM'), :date))
  end

  def self.surrounding_months(year, month)
    counts = month_counts().all
  end

end
