module ThylogaleUtils
  def random_string(len = 10)
    rand_max = RAND_CHARS.size
    result   = ''
    len.times { result << RAND_CHARS[rand(rand_max)] }
    result
  end
  module_function :random_string

  def get_mime(extension)
    Mime::Type.lookup_by_extension(extension)
  end
  module_function :get_mime

  def get_mime_from_file_name(file_name)
    get_mime(File.extname_without_dot(file_name))
  end
  module_function :get_mime_from_file_name

  def get_extension(mime)
    Mime::Type.lookup(mime).to_sym
  end
  module_function :get_extension

  private

  RAND_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
end