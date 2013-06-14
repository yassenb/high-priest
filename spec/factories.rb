FactoryGirl.define do
  factory :user do
    email { "#{username.split.join(".").downcase}@gmail.com" }

    password "secret123"
    password_confirmation { password }

    sequence(:username) { |n| "user#{n}" }
  end

  factory :game do
    sequence(:name) { |n| "game#{n}" }
  end
end
