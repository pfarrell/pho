class MyModel
  def hello(str=nil)
    str = "friend" if str.nil? || str.empty?
    "cioa, #{str}"
  end
end
