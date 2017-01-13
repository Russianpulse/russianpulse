class Tag < ActiveRecord::Base
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  serialize :post_ids, JSON

  before_save :remove_dups

  def title=(value)
    result = super
    set_slug

    result
  end

  def posts
    Post.where(id: post_ids)
  end

  def self_and_aliases
    [title] + aliases.to_s.split(',').map(&:strip)
  end

  def russian?
    !!(title.to_s + aliases.to_s).mb_chars.downcase.match(/[а-я]/)
  end

  private

  def remove_dups
    self.post_ids = (post_ids || []).compact.uniq
  end

  def self.generate_slug(title)
    title.parameterize
  end

  def set_slug
    self.slug = self.class.generate_slug(title)
  end
end
