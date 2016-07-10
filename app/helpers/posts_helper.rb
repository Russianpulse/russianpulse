# helpers for posts
module PostsHelper
  def typography(html)
    raw Typogruby.improve(html)
  end

  def permalink_url(post)
    post_permalink_url(post.slug_id.presence || post.id)
  end

  def smart_post_path(post, options={})
    blog_slug = Rails.cache.fetch("Blog#slug##{post.blog_id}", expires_in: 1.hour) { post.blog.slug }

    options = {
      controller: :posts, action: :show,
      blog: blog_slug,
      year: post.created_at.year,
      month: post.created_at.strftime('%m'),
      day: post.created_at.strftime('%d'),
    }.merge(options)

    options[:id] = post.to_param
    post_url options.merge( :only_path => true )
  end

  def smart_post_url(post, options={})
    "http://#{Rails.configuration.x.domain}#{smart_post_path(post, options)}"
  end

  def format_post(html)
    Rails.cache.fetch("format_post##{Digest::SHA256.hexdigest(html.to_s)}") do
      format_post_uncached html
    end
  end

  def format_post_uncached(html)
    # плохая штука...
    # html = html.gsub("\n", "\n\n")

    html = html.to_s

    ###########################################################################
    # Mardown
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    html = markdown.render(html)

    ###########################################################################
    # Nokogiri 1

    doc = Nokogiri::HTML::DocumentFragment.parse(html)

    doc.css('br').each do |br|
      br.add_next_sibling("\n\n")
    end

    doc.css('p,div').each do |el|
      el.replace "\n\n<br /><br />#{el.inner_html}<br /><br />\n\n"
    end

    ###########################################################################
    # Headers levelize
    max_header_level = nil

    (1..6).each do |level|
      max_header_level = level if doc.css("h#{level}").size > 0
      break if max_header_level.present?
    end


    if max_header_level.present?
      range = max_header_level < 2 ? (6).downto(max_header_level) : max_header_level.upto(6)

      range.each do |level|
        doc.css("h#{level}").each do |el|
          new_level = level - (max_header_level - 2)
          el.replace "<h#{new_level}>#{el.inner_html}</h#{new_level}>"
        end
      end
    end


    html = doc.to_html

    ###########################################################################
    # Sanitize

    html = sanitize(simple_format(html, {}, sanitize: false), tags: %w(h2 h3 h4 h5 h6 p a strong i b blockquote stroke ul li ol em del img cut table tr td th video iframe embded object), attributes: %w(href src alt title name start))

    ###########################################################################
    # Nokogiri 2

    # All custom classes should be added after simple_format call,
    # because they will be removed by it
    doc = Nokogiri::HTML::DocumentFragment.parse(html)

    doc.css('img').each do |img|
      img['class'] = 'img-responsive center-block'
    end

    doc.css('a').each do |img|
      img['target'] = '_blank'
    end

    doc.css('embded,video,iframe,object').each do |el|
      el['class'] = 'embed-responsive-item'
      el.replace "<div class=\"embed-responsive embed-responsive-16by9\">#{el.to_html}</div>"
    end

    doc.css('p').each do |el|
      if el.text.remove(/[[:space:]]+/m).blank?
        if el.css('img,iframe,video').size == 0
          el.remove 
        end
      end
    end

    doc.css('p').each do |el|
      el['class'] = 'tiny' if el.text.strip.size < 200
    end

    html = doc.to_html


    raw html
  end

  def post_descritpion_has_image?(post)
    Nokogiri::HTML(post_description_with_cut(post)).css('img').size > 0
  end

  def post_description_short(post, max_length = 500)
    text_short(post.body, max_length)
  end

  def text_short(html, max_length = 500)
    text = strip_tags(CGI.unescapeHTML(html))

    if text.mb_chars.length > max_length
      text = text.mb_chars[0..max_length - 1]

      result = text.sub(/[^.!?]+\z/, '')

      if result.size < (max_length * 0.65)
        result = text[0..-6] + ' […] '
      end

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
