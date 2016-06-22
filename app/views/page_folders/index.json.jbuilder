json.array!(@page_folders) do |page_folder|
  json.extract! page_folder, :id, :path
  json.url page_folder_url(page_folder, format: :json)
end
