FactoryGirl.define do
  factory :podcast do
    title 'Title'
    sequence(:slug) { |n| "podcast-#{n}" }
    avatar_url 'http://example.com/avatar.jpeg'

    trait :featured do
      featured true
    end
  end
end
