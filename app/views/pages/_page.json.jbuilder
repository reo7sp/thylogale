json.extract! page, :id, :title, :name, :path, :build_path, :published

if page.root_folder.nil?
  json.root_folder nil
else
  json.root_folder page.root_folder, :id
end

json.extract! page, :created_at, :updated_at