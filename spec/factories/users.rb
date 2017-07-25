FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name) { |n| "User #{n}" }
    password 'secret123'

    trait :admin do
      role 'admin'
    end
  end
end
