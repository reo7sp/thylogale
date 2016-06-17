class ThylogaleConfig
  def site_location
    ENV["SITE_LOCATION"]
  end

  def pages_location
    "#{site_location}/pages"
  end

  def assets_location
    "#{site_location}/assets"
  end

  def meta_location
    "#{site_location}/meta"
  end

  def template_location
    "#{site_location}/template"
  end

  def data_location
    "#{site_location}/data"
  end
end