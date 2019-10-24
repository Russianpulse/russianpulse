FactoryGirl.define do
  factory :comment do
    comment 'Some comment'
    user
    commentable { build :post }

    trait :spam do
      spam { true }
    end
  end
end
