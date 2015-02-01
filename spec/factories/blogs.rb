FactoryGirl.define do
  factory :blog do
    title "Title"
    sequence(:slug) { |n| "blog-#{n}" }

    trait :featured do
      featured true
    end
  end
end
