Thylogale.template 'page' do
  file_extension 'md'

  on_save do
    pipe :download_external_images
  end

  on_publish do
    pipe :downgrade_headings
    pipe :markdown
    pipe :template, 'page.html.liquid'
  end
end

Thylogale.template 'generated page' do
  file_extension 'md.liquid'

  on_save do
    pipe :download_external_images
  end

  on_publish do
    pipe :liquid
    pipe :downgrade_headings
    pipe :markdown
    pipe :template, 'page.html.liquid'
  end
end