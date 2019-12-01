class Summary
  def self.all
    DB[:photos].group_and_count(Sequel.as(Sequel.function(:date_part, 'year', :date), 'year')).all
  end

  def self.by_year(year)
    DB[:photos].where(Sequel.function(:date_part, 'year', :date) => year).group_and_count(Sequel.as(Sequel.function(:date_part, 'month', :date), 'month')).all
  end
end
