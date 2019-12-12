class Summary
  def self.all
    DB[:pfiles]
      .group_and_count(Sequel.as(Sequel.function(:date_part, 'year', :date), 'year'))
      .order(Sequel.desc(:year))
      .all
  end

  def self.by_year(year)
    DB[:pfiles]
      .where(Sequel.function(:date_part, 'year', :date) => year)
      .group_and_count(Sequel.as(Sequel.function(:date_part, 'month', :date), 'month'))
      .order(:month)
      .all
  end

  def self.month_counts()
    Pfile.group_and_count(Sequel.as(Sequel.function(:to_char, :date, 'YYYY-MM'), :date))
  end

end
