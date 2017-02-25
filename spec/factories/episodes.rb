FactoryGirl.define do
  factory :episode do
    sequence(:title) { |n| "Title #{n}" }
    body 'Body'
    podcast

    enclosures ['http://example.com/some-path.mp3']
  end
end
