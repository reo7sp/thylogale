module Thylogale
  module Locations

    def self.sites_default
      ENV['SITES_DEFAULT_LOCATION'] ||= '/var/lib/thylogale/sites'
    end

  end
end
