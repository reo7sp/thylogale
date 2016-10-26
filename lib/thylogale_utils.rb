module ThylogaleUtils
  module_function

  def random_string(len = 10)
    rand_max = RAND_CHARS.size
    result   = ''
    len.times { result << RAND_CHARS[rand(rand_max)] }
    result
  end

  def get_mime(extension)
    Mime::Type.lookup_by_extension(extension)
  end

  def get_mime_from_file_name(file_name)
    get_mime(File.extname_without_dot(file_name))
  end

  def get_extension(mime)
    Mime::Type.lookup(mime).to_sym
  end

  private

  RAND_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
end