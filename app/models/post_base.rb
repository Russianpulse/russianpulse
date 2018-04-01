class PostBase < ApplicationRecord
  self.table_name = 'posts'

  acts_as_commentable
  acts_as_followable

  serialize :related_ids, JSON

  belongs_to :blog, class_name: 'BlogBase'

  delegate :title, to: :blog, prefix: true, allow_nil: true

  validates :title, presence: true
  validates :body, presence: true
  validates :blog, presence: true

  scope :recent, -> { order("#{table_name}.created_at DESC") }
  scope :newer_than, ->(date) { where("#{table_name}.created_at > ?", date) }
  scope :older_than, ->(date) { where("#{table_name}.created_at < ?", date) }
  scope :created_between, ->(from, to) { where("#{table_name}.created_at >= ? AND #{table_name}.created_at <= ?", from, to) }

  COMMENTS_POWER = 1000
  scope :popular, -> { order("(views + comments_count * #{COMMENTS_POWER}) DESC NULLS LAST") }
  scope :unpopular, -> { order("(views + comments_count * #{COMMENTS_POWER}), accessed_at DESC NULLS FIRST") }

  scope :top, -> { where('top = ? OR comments_count > 0', true) }
  scope :not_top, -> { where('top = ? AND comments_count = 0', false) }
  scope :with_picture, -> { where("picture_url LIKE '%//%'") }
  scope :most_discussed, -> { where('comments_count > 0').order('comments_count DESC') }
  scope :published, -> { where(blocked_at: nil) }

  before_create :set_accessed_at

  before_save :nilify_slug_if_blank
  before_save :block_if_trashed
  after_save :set_friendly_param

  def blocked?
    blocked_at.present?
  end

  def has_comments?
    comments_count > 0
  end

  def source_url
    self[:source_url] unless blog.hide_source_url?
  end

  def title
    super.html_safe if super.present?
  end

  def has_picture?
    picture_url.present?
  end

  def picture_url
    self[:picture_url].to_s.gsub(/^http:/, '')
  end

  def tags
    self.class.tags_from_tags_list(tags_list)
  end

  def tags_was
    self.class.tags_from_tags_list(tags_list_was)
  end

  def to_param
    friendly_param.presence || "#{id}-#{title.parameterize}"
  end

  def related(options = {})
    limit = options[:limit] || 10

    ids = Rails.cache.fetch("#{cache_key}#related##{options.to_json}") do
      result = []

      _tags = tags

      (1..[_tags.size, 3].min).to_a.reverse.each do |n|
        _tags.sort_by { |t| t.post_ids.size }.combination(n).each do |tags_combination|
          tagged = tags_combination.map(&:post_ids).inject(&:&)

          tagged ||= []

          tagged -= [id]

          # only older than current
          result += tagged.reject { |id| id > self.id }

          result = result.uniq

          break if result.size >= limit
        end

        break if result.size >= limit
      end

      result.sort.reverse.take(limit)
    end

    posts = Post.where(id: ids).recent

    posts
  end

  private_class_method

  def self.tags_from_tags_list(tags_list)
    Tag.where(slug: tags_list.to_s.split(',')
      .map(&:strip).map { |t| Tag.generate_slug(t) }
      .uniq.compact).sort_by { |t| t.post_ids.size }
  end

  private

  def set_accessed_at
    self.accessed_at = created_at
  end

  def nilify_slug_if_blank
    self.slug_id = nil if slug_id.blank?
  end

  def set_friendly_param
    self.friendly_param = to_param if friendly_param.blank?
  end

  def block_if_trashed
    if stream == 'trash'
      self.blocked_at ||= Time.now
    else
      self.blocked_at = nil
    end
  end
end
