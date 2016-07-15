require 'fileutils'

module Thylogale
  class LocalFileContainer
    attr_reader :path

    def initialize(path, setup)
      @path  = path
      @setup = setup
    end

    def abs_path(path = @path)
      File.join(@setup.save_local_dir, path)
    end

    def create
      FileUtils.mkdir_p(File.dirname(abs_path))
      FileUtils.touch(abs_path)
    end

    def destroy
      FileUtils.rm(abs_path)
    end

    def copy(to_path)
      FileUtils.mkdir_p(File.dirname(abs_path(to_path)))
      FileUtils.cp(abs_path, abs_path(to_path))
    end

    def move(to_path)
      FileUtils.mkdir_p(File.dirname(abs_path(to_path)))
      FileUtils.mv(abs_path, abs_path(to_path))
    end

    def read
      File.read(abs_path)
    end

    def write(text)
      File.write(abs_path, text)
    end

    def cache
      file = Tempfile.new
      file.write(read)
      file
    end
  end
end