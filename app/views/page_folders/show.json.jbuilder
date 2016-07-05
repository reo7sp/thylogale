json.extract! @page_folder, :id, :title, :name, :path

json.subdirectories @page_folder.subdirectories, :id
json.pages @page_folder.pages, :id

json.extract! @page_folder, :created_at, :updated_at
