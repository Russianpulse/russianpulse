class BlogBase < ApplicationRecord
  self.table_name = 'blogs'

  FETCH_SUCCESS = 0
  FETCH_FAILED = 1
  MAX_FETCHES_STORED = 10
  serialize :recent_fetches, Array

  has_many :posts, dependent: :destroy, foreign_key: :blog_id, class_name: 'PostBase'

  validates :title, presence: true
  validates :slug, presence: true
  validates :fetch_type, inclusion: { in: %w[net_http], allow_blank: true }

  scope :with_feed, -> { where("feed_url LIKE 'http%'") }
  scope :popular, -> { order('rating DESC') }

  def text_cleanup_rules_auto
    rules = text_cleanup_rules || ''

    if feed_url.try(:match, /ftr.fivefilters.org/)
      rules << "\n" if rules.present?
      rules << 'remove regexp /This entry passed through the Full-Text RSS service.+/im'
      rules << "\n"
      rules << 'remove regexp /Let\'s block ads!/'
      rules << "\n"
      rules << 'remove regexp /\(Why\?\)/'
    end

    if feed_url.try(:match, /feeds.feedburner.com/)
      rules << "\n" if rules.present?
      rules << 'remove css .feedflare'
    end

    rules
  end

  def duration_having_posts(number)
    return nil unless posts.exists?
    return (Time.current - posts.minimum(:created_at)).seconds if posts.count <= number

    (Time.current - posts.order(:created_at).offset(number).limit(1).pluck(:created_at).first).seconds
  end

  def cleanup_html(html)
    # удаляем комментарии
    doc = Nokogiri::HTML::DocumentFragment.parse(html)
    doc.xpath('//comment()').remove
    html = doc.to_html

    text_cleanup_rules_auto.to_s.split("\n").map(&:strip).each_with_index do |line, index|
      match = line.match(/^([^\s]+)\s+([^\s]+)\s+(.*)/)

      if match
        cmd = match[1]
        args = [match[2], match[3].strip]

        case cmd
        when 'remove'

          case args[0]
          when 'regexp'
            regexp = eval(args[1])

            html = html.remove regexp
          when 'css'
            doc = Nokogiri::HTML::DocumentFragment.parse(html)
            doc.css(args[1]).each(&:remove)

            html = doc.to_html
          else
            raise "unknown remove type '#{args[0]}': '#{line}'"
          end

        when 'select'
          case args[0]
          when 'css'
            doc = Nokogiri::HTML::DocumentFragment.parse(html)

            el = doc.css(args[1])[0]

            if el.present?
              html = doc.css(args[1])[0].to_html
            else
              raise "Can't find anything by css selector '#{args[1]}'"
            end
          else
            raise "unknown remove type '#{args[0]}': '#{line}'"
          end

        else
          raise "unknown cmd '#{cmd}'"
        end
      else
        raise "failed to parse line ##{index}: #{line}"
      end
    end

    html
  end

  def checked!
    recent_fetches.push [FETCH_SUCCESS, nil]
    update_health_status
  end

  def failed_to_check!(exception = nil)
    recent_fetches.push [FETCH_FAILED, exception.try(:to_s)]
    update_health_status
  end

  private

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
