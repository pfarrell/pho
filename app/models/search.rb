class Search < Sequel::Model

  def start_date
    self.daterange.gsub(/\/.*/, '')
  end

  def end_date
    self.daterange.gsub(/.*\//, '')
  end
end
