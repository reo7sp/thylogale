module PagesHelper
  def site_page_path(page)
    "http://#{FirstSetup.instance.site_domain}/#{page.build_path}"
  end
end
