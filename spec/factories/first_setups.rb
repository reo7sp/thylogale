FactoryGirl.define do
  factory :first_setup do
    id 1
    done false

    factory :done_first_setup do
      done true
      import_choice 'local'
      save_choice 'local'
      email_choice 'local'
      site_domain 'example.com'
      save_local_dir "/tmp/thylogale-test-#{Random.rand}/example.com"
    end
  end
end
