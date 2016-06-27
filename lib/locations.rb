module Locations
  def self.sites_default
    ENV['SITE_DEFAULT_LOCATION'] || '/var/lib/thylogale/sites'
  end
end
