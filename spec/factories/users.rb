require 'securerandom'

FactoryGirl.define do
  factory :user do
    name { SecureRandom.hex(8) }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { SecureRandom.hex(8) }

    factory :admin_user do
      id 1
      name 'admin'
    end
  end
end
