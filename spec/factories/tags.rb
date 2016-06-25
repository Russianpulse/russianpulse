FactoryGirl.define do
  factory :tag do
    sequence(:title) { |n| "Tag #{n}" }
    sequence(:slug) { |n| "tag-#{n}" }
  end

end
