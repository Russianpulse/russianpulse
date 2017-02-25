FactoryGirl.define do
  factory :blog do
    title 'Title'
    sequence(:slug) { |n| "blog-#{n}" }

    trait :featured do
      featured true
    end
  end

  factory :podcast do
    title 'Title'
    sequence(:slug) { |n| "podcast-#{n}" }

    trait :featured do
      featured true
    end
  end
end
