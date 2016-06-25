FactoryGirl.define do
  factory :post_teaser do
    sequence(:body) { |n| "Teaser text #{n}" }
  end
end
