class UpdateBlogJob < ActiveJob::Base
  queue_as :default

  def perform(blog, force=false)
    return unless need_check?(blog) || force

    logger.info "Updating blog #{blog.id} feed '#{blog.feed_url}'"
    result = Feedjira::Feed.fetch_and_parse(blog.feed_url, :timeout => 30)

    if result.is_a? Numeric
      raise "Updating blog #{blog.id} faild, feedzirra status code '#{result}'"
    end

    feed = result

    not_older_than = blog.posts.maximum(:created_at) || created_at

    # сначала старые
    feed.entries.reverse.each do |entry|
      if entry.published.present? && entry.published < not_older_than
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

      title = entry.title.mb_chars[0..124] rescue nil

      if title.present?
        pub_date = if entry.published.blank?
                     Time.now
                   elsif entry.published < (checked_at || 1.hour.ago)
                     (checked_at || 1.hour.ago)
                   else
                     [entry.published.to_time, Time.now].min
                   end


        post = blog.posts.create!(:title  => title, :body => post_body, :source_url => entry_url, :created_at => pub_date)

        logger.info "Post ##{post.id} created!"

        #PostFullTextWorker.perform_async(post.id)
      else
        logger.error "Entry #{entry_url} has no title!"
      end
    end

    blog.touch(:checked_at)
    update_average_period
  end

  def need_check?(blog)
    blog.checked_at.blank? || blog.checked_at < 1.hour.ago || blog.checked_at < (1.hour / blog.posts_per_hour).seconds.ago
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

  def update_average_period(blog)
    recent_posts = blog.posts.order("created_at DESC").limit(5)

    return if recent_posts.blank?

    # в минутах
    blog.update_column :average_period, ((blog.checked_at || Time.now) - recent_posts.last.created_at) / 60 / recent_posts.size
  end
end
