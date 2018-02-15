FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Title #{n}" }
    body 'Body'
    blog

    trait :top do
      top true
    end

    trait :ads do
      stream :partners
    end

    trait :blocked do
      stream :trash
      blocked_at { 5.minutes.ago }
    end

    trait :commented do
      after :create do |post, _|
        FactoryGirl.create(:comment, commentable: post)
      end
    end
  end
end
