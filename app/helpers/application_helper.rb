module ApplicationHelper
  def counter_tag(post_id, _options = {})
    raw "<img src='/p/views/#{post_id}.png' alt='' title='' width=1, height=1 />"
  end

  def proxy_image_url(url, size = '')
    if ENV['IMAGEPROXY_URL'].present?
      File.join(ENV['IMAGEPROXY_URL'], size.to_s, url.to_s)
    else
      url
    end
  end

  def proxy_all_images(html)
    doc = Nokogiri::HTML::DocumentFragment.parse(html)

    doc.css('img').each do |img|
      img['src'] = proxy_image_url(img['src'])
    end

    doc.to_html
  end

  def glyphicon(name, _type = :bootstrap)
    content_tag(:i, nil, class: "glyphicon glyphicon-#{name}")
  end

  def smart_date(date)
    content_tag :span, l(date, format: '%e.%m.%Y %H:%M'), class: 'smart-date', 'data-dt' => date.iso8601
  end

  def time_or_date(date)
    content_tag :span, l(date, format: '%e.%m.%Y %H:%M'), class: 'time-or-date', 'data-dt' => date.iso8601
  end

  def format_date(date, time: true)
    f = time ? '%H:%M &nbsp;  %e %b %Y' : '%e %b %Y'
    raw(localize(date, format: f))
  end

  def bootstrap_class_for(flash_type)
    { success: 'alert-success', error: 'alert-danger', alert: 'alert-warning', notice: 'alert-info' }[flash_type] || flash_type.to_s
  end

  def send_ga_events
    events = session.try(:[], :ga_events)

    if events.present?
      javascript_tag do
        events.each do |event|
          concat raw("ga('send', 'event', '#{event['category']}', '#{event['action']}', '#{event['label']}', #{event['value'] || 1}, {'nonInteraction': #{event['interaction'] ? 0 : 1}});")
        end

        # clear to not send twice
        session[:ga_events] = []
      end
    end
  end

  def recaptcha_tags
    capture do
      concat javascript_include_tag('https://www.google.com/recaptcha/api.js')
      concat content_tag(:div, nil, class: 'g-recaptcha', 'data-sitekey' => ENV['RECAPTCHA_PUBLIC_KEY'].html_safe)
    end
  end

  def js_redirect_to(target)
    javascript_tag do
      concat raw(
        <<-JS
      setTimeout(function() {
        window.location.href = "#{target}";
      }, 3000)
      JS
      )
    end
  end

  def benchmark(name)
    t0 = Time.now.in_time_zone

    yield

    t1 = Time.now.in_time_zone

    Rails.logger.debug "TEMPLATE BENCHMARK '#{name}': #{t1 - t0}"
  end
end
