# helpers for posts
module PostsHelper
  def typography(html)
    raw Typogruby.improve(html)
  end

  def permalink_url(post)
    post_permalink_url(post.slug_id.presence || post.id)
  end

  def smart_post_path(post, options = {})
    blog_slug = Rails.cache.fetch("Blog#slug##{post.blog_id}", expires_in: 1.hour) { post.blog.slug }

    options = {
      controller: :posts, action: :show,
      blog: blog_slug,
      year: post.created_at.year,
      month: post.created_at.strftime('%m'),
      day: post.created_at.strftime('%d')
    }.merge(options)

    options[:id] = post.to_param
    post_url options.merge(only_path: true)
  end

  def smart_post_url(post, options = {})
    "http://#{Rails.configuration.x.domain}#{smart_post_path(post, options)}"
  end

  def post_descritpion_has_image?(post)
    !Nokogiri::HTML(post_description_with_cut(post)).css('img').empty?
  end

  def post_description_short(post, max_length = 500)
    text_short(post.body, max_length)
  end

  def text_short(html, max_length = 500)
    text = strip_tags(CGI.unescapeHTML(html))

    if text.mb_chars.length > max_length
      text = text.mb_chars[0..max_length - 1]

      result = text.sub(/[^.!?]+\z/, '')

      result = text[0..-6] + ' […] ' if result.size < (max_length * 0.65)

      raw(result)
    else
      text
    end
  end

  def post_teaser_for(post)
    return nil unless PostTeaser.exists?
    PostTeaser.offset(post.id % PostTeaser.count).first.body
  end
end
