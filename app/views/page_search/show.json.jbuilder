json.query @query

results_by_type = @search_results.group_by(&:class)
pages = results_by_type[Page]
page_folders = results_by_type[PageFolder]

json.result do
  json.pages pages, partial: 'pages/page', as: :page
  json.page_folders page_folders, partial: 'page_folders/page_folder', as: :page_folder
end
