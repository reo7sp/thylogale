class LocalPageContainer
  def initialize(page, setup)
    @page  = page
    @setup = setup
  end

  def abs_path(path = @page.path)
    File.join(@setup.save_local_dir, 'pages', path)
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
end