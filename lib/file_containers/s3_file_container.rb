require 'aws-sdk-resources'

module Thylogale
  class S3FileContainer
    attr_reader :path

    def initialize(path, setup)
      @path   = path
      @setup  = setup
      @bucket = Aws::S3::Resource.new.bucket("#{@setup.site_domain}_site_data")
      @bucket.create unless @bucket.exists?
      @object = @bucket.object(abs_path)
    end

    def abs_path(path = @path)
      File.join(@setup.save_local_dir, path)
    end

    def create
      @object.put(body: '')
    end

    def destroy
      @object.delete
    end

    def copy(to_path)
      @object.copy_to(abs_path(to_path))
    end

    def move(to_path)
      @object.move_to(abs_path(to_path))
    end

    def read
      @object.get
    end

    def write(text)
      @object.put(text)
    end

    def cache
      file = Tempfile.new
      file.write(read)
      file
    end
  end
end
