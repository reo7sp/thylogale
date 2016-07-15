require 'file_containers/local_file_container'
require 'file_containers/s3_file_container'

module Thylogale
  def file_container(*path_array)
    path = File.join(path_array)
    setup = FirstSetup.instance
    case setup.save_choice
    when 'local'
      LocalFileContainer.new(path, setup)
    when 's3'
      S3FileContainer.new(path, setup)
    end
  end
end