class PostDigest < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true

  before_save :remove_dups

  def posts
    Post.where(id: post_ids.split(','))
  end

  private

  def remove_dups
    self.post_ids = post_ids.split(/[^[:digit:]]+/m).map(&:to_i).compact.uniq.join(',')
  end
end
