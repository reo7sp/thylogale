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
      f = abs_path
      FileUtils.mkdir_p(File.dirname(f))
      FileUtils.touch(f)
    end

    def destroy
      f = abs_path
      FileUtils.rm(f)
      rm_r_empty(File.dirname(f))
    end

    def copy(to_path)
      f    = abs_path
      to_f = abs_path(to_path)
      FileUtils.mkdir_p(File.dirname(to_f))
      FileUtils.cp(f, to_f)
    end

    def move(to_path)
      f    = abs_path
      to_f = abs_path(to_path)
      FileUtils.mkdir_p(File.dirname(to_f))
      FileUtils.mv(f, to_f)
      rm_r_empty(File.dirname(f))
    end

    def read
      File.binread(abs_path)
    end

    def write(text)
      f = abs_path
      FileUtils.mkdir_p(File.dirname(f))
      File.binwrite(f, text)
    end

    def cache(open: true, fast: false)
      if fast
        File.new(abs_path)
      else
        file = Tempfile.new
        file.binwrite(read)
        file.close
        file.open if open
        file
      end
    end

    private

    def rm_r_empty(dir)
      if Dir.empty?(dir)
        FileUtils.rm_r(dir)
        rm_r_empty(File.dirname(dir))
      end
    end
  end
end