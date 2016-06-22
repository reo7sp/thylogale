json.array!(@pages) do |page|
  json.extract! page, :id, :title, :slug, :template, :page_folder_id
  json.url page_url(page, format: :json)
end
