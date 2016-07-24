module ApplicationHelper
  def glyphicon(name)
    "<span class=\"glyphicon glyphicon-#{name}\" aria-hidden=\"true\"></span>".html_safe
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
end
