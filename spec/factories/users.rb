FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name) { |n| "User #{n}" }
    password 'secret123'
    confirmed_at { 1.day.ago }

    trait :admin do
      role 'admin'
    end
  end
end
