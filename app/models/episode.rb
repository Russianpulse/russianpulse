class Episode < PostBase
  belongs_to :podcast, foreign_key: :blog_id
  serialize :enclosures, JSON

  validates :enclosures, presence: true
end
