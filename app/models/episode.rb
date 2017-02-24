class Episode < PostBase
  belongs_to :podcast, foreign_key: :blog_id
end

