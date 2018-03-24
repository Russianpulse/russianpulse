class Episode < PostBase
  belongs_to :podcast, foreign_key: :blog_id
  serialize :enclosures, JSON

  validates :enclosures, presence: true

  def enclosure_mp3
    enclosures.find { |url| url.match(/mp3/) }
  end
end
