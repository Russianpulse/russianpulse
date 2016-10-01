require 'timeout'

class UpdateBlogJob < ActiveJob::Base
  queue_as :default

  include ActionView::Helpers::SanitizeHelper

  def perform(blog=nil, force=false)
    if blog.nil?
      Blog.with_feed.find_each do |blog|
        UpdateBlogJob.perform_later blog
      end

      return
    end

    return unless need_check?(blog) || force

    logger.info "Updating blog #{blog.id} feed '#{blog.feed_url}'"

    result = Timeout::timeout(30) do
      Feedjira::Feed.fetch_and_parse(blog.feed_url)
    end

    EventTracker.track "Blogs", "Feed update", blog.title

    if result.is_a? Numeric
      raise "Updating blog #{blog.id} faild, feedzirra status code '#{result}'"
    end

    feed = result

    not_older_than = blog.posts.maximum(:created_at)

    # сначала старые
    feed.entries.reverse.each do |entry|
      if not_older_than.present? && entry.published.present? && entry.published < not_older_than
        logger.warn "Entry #{entry.url} is old"
        next
      end

      if entry.url.blank?
        logger.error "Entry has blank url"
        next
      end

      entry_url = url_after_redirects(entry.url)

      # иначе youtube ленты содержат дубликаты
      entry_url.sub("&feature=youtube_gdata", "")

      post_body = entry.content.presence || entry.summary || ""

      if blog.posts.exists?(:source_url => entry_url)
        # TODO: обновлять статью
        logger.warn "Entry #{entry.url} is already added"
        next
      end

      title = entry.title

      if title.present?
        pub_date = if entry.published.blank?
                     Time.now
                   elsif entry.published < (blog.checked_at || 1.hour.ago)
                     (blog.checked_at || 1.hour.ago)
                   else
                     [entry.published.to_time, Time.now].min
                   end

        if caps? title
          title = title.mb_chars.capitalize.to_s
        end

        post = blog.posts.new({
          body: HtmlCleanup.new(blog.cleanup_html(post_body)).cleanup,
          created_at: pub_date,
          source_url: entry_url,
          title: Typogruby.improve(strip_tags(title)),
          stream: blog.default_stream
        })

        if post.valid?
          post.save!
          EventTracker.track "Blogs", "Created post via Feed", blog.title
          TaggerJob.perform_later post
          ImageFinderJob.perform_later post

          logger.info "Post ##{post.id} created!"
        else
          EventTracker.track "Blogs", "Failed to create post via Feed", blog.title
        end
      else
        logger.error "Entry #{entry_url} has no title!"
      end
    end

    blog.checked!
  rescue Feedjira::FetchFailure, Timeout::Error => ex
    blog.failed_to_check!(ex)
  rescue StandardError => ex
    blog.failed_to_check!(ex)
    raise
  end

  def need_check?(blog)
    posts_per_hour = [blog.posts_per_hour || 1, 1].max
    blog.checked_at.blank? || blog.checked_at < 1.hour.ago || blog.checked_at < (1.hour / (posts_per_hour || 1)).seconds.ago
  end

  # получаем полный url - после редиректов
  def url_after_redirects(source_url)
    follow_url = lambda { |url| HTTPClient.new.head(url).header['Location'][0] }

    target_url = source_url

    loop do
      next_url = follow_url.call(target_url)

      break if next_url.blank?

      target_url = next_url
    end

    target_url
  rescue
    source_url
  end

  def caps?(text)
    text.strip.present? && !text.match(/[a-zа-я]+/)
  end
end
