Thylogale.template 'page' do
  file_extension 'md'

  pipe :markdown
  pipe :template, 'page.html.liquid'
end

Thylogale.template 'generated page' do
  file_extension 'md.liquid'

  pipe :liquid
  pipe :markdown
  pipe :template, 'page.html.liquid'
end