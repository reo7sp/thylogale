class Dir
  def self.empty?(dir)
    entries(dir).without('.', '..').empty?
  end
end

