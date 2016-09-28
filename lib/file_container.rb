module FileContainer
  def self.new(path)
    setup = FirstSetup.instance

    case setup.save_choice
    when 'local'
      FileContainers::LocalFileContainer.new(path, setup)
    when 's3'
      FileContainers::S3FileContainer.new(path, setup)
    end
  end
end