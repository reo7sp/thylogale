require 'rubygems'
require 'sitemap_generator'
require 'tempfile'

Thylogale.template_pipe 'sitemap' do
  sitemap_file = Tempfile.new
  sitemap_file.close

  SitemapGenerator::Sitemap.default_host = Thylogale.config.site_domain
  SitemapGenerator::Sitemap.sitemaps_path = sitemap_file.path

  SitemapGenerator::Sitemap.create do
    Pages.find_each do |page|
      add page.path
    end
  end

  sitemap_file.open
  Thylogale.file_container('static', 'sitemap.xml.gz').write(sitemap_file.binread)
  sitemap_file.close! rescue

  SitemapGenerator::Sitemap.ping_search_engines
end
