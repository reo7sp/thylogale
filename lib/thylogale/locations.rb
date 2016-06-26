module Thylogale
  module Locations
    def site_default
      ENV['SITE_DEFAULT_LOCATION'] || '/var/lib/thylogale/site'
    end
  end
end