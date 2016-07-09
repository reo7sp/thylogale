FactoryGirl.define do
  factory :page do
    title 'Test page'
    name 'test-page'
    path '/test-page'
    root_folder_id 1
  end
end
