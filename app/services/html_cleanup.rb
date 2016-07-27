class HtmlCleanup
  include ActionView::Helpers::TextHelper

  def initialize(html)
    @html = html
  end

  def cleanup
    Typogruby.improve format_html(@html)
  end

  private

  def format_html(html)
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
end
