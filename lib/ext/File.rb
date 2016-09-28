class File
  def self.extname_without_dot(file)
    extname(file)[1..-1]
  end
end