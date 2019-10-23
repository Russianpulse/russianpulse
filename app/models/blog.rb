class Blog < ApplicationRecord
  FETCH_SUCCESS = 0
  FETCH_FAILED = 1
  MAX_FETCHES_STORED = 10
  serialize :recent_fetches, Array

  has_many :posts, dependent: :destroy, foreign_key: :blog_id, class_name: 'Post'
  has_many :authors, class_name: 'BlogUser'

  validates :title, presence: true
  validates :slug, presence: true
  validates :fetch_type, inclusion: { in: %w[net_http], allow_blank: true }

  scope :with_feed, -> { where("feed_url LIKE 'http%'") }
  scope :popular, -> { order('rating DESC') }

  def duration_having_posts(number)
    return nil unless posts.exists?
    return (Time.current - posts.minimum(:created_at)).seconds if posts.count <= number

    (Time.current - posts.order('created_at DESC').offset(number).limit(1).pluck(:created_at).first).seconds
  end

  def cleanup_html(html)
    readability_service.call(html, text_cleanup_rules_array)
  end

  def checked!
    recent_fetches.push [FETCH_SUCCESS, nil]
    update_health_status
  end

  def failed_to_check!(exception = nil)
    recent_fetches.push [FETCH_FAILED, exception.try(:to_s)]
    update_health_status
  end

  def text_cleanup_rules_array
    (self[:text_cleanup_rules] || '').split("\n")
  end

  private

  def readability_service
    @readability_service || ReadabilityService.new
  end

  def update_health_status
    truncate_recent_fetches
    refresh_health_status

    update_columns(
      recent_fetches: recent_fetches,
      checked_at: Time.now.in_time_zone
    )
  end

  def refresh_health_status
    new_status = recent_fetches.map do |fetch|
      fetch[0] == FETCH_SUCCESS ? 0 : 1
    end.sum

    self.health_status = new_status
  end

  def truncate_recent_fetches
    recent_fetches.shift while recent_fetches.size > MAX_FETCHES_STORED
  end
end
