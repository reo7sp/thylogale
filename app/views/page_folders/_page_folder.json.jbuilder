json.extract! page_folder, :id, :title, :name, :path, :build_path

if page_folder.root_folder.nil?
  json.root_folder nil
else
  json.root_folder page_folder.root_folder, :id
end

json.subfolders page_folder.subfolders, :id
json.pages page_folder.pages, :id

json.extract! page_folder, :created_at, :updated_at