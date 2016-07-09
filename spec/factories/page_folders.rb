FactoryGirl.define do
  factory :page_folder do
    title 'Test folder'
    name 'test-folder'
    path '/test-folder'
    root_folder_id 1

    factory :root_page_folder do
      id 1
      title 'Site'
      name '/'
      path '/'
      root_folder_id nil
    end
  end
end
