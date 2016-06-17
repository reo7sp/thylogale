class PageFolder < FileSystemNodeModel
  alias_method :id, :path
  alias_method :id=, :path=

  def root_location
    ThylogaleConfig.pages_location
  end

  def contents
    Dir.new(abs_path).from(2).map do |name|
      if File.directory?("#{dir.path}/#{name}")
        PageFolder.new(name: name, location: dir.path)
      else
        Page.new(name: name, location: dir.path)
      end
    end
  end

  def self.create(hash)
    folder = new(hash)
    FileUtils.mkdir(folder.abs_path)
    folder
  end

  def self.find(id)
    find_by(id: id)
  end

  def self.find_by(hash)
    folder = new(hash)
    if Dir.exists?(folder.abs_path)
      folder
    else
      nil
    end
  end
end