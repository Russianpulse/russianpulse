FactoryGirl.define do
  factory :comment do
    comment "Some comment"
    user
    commentable { build :post }
  end
end
