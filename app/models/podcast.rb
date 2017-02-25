class Podcast < BlogBase
  alias episodes posts
  validates :avatar_url, presence: true
end
