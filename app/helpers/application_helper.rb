module ApplicationHelper
  def counter_tag(post_id, _options = {})
    raw "<img src='/p/views/#{post_id}.png' alt='' title='' width=1, height=1 />"
  end

  def glyphicon(name, _type = :bootstrap)
    content_tag(:i, nil, class: "glyphicon glyphicon-#{name}")
  end

  def smart_date(date)
    if date > 1.minute.ago
      t 'just_now'
    elsif date > 60.minutes.ago
      minutes = ((Time.now - date) / 1.minute).round
      unit = Russian.pluralize(minutes, 'minute', 'minutes', 'minutes_5')

      "#{minutes} #{t unit} #{t :ago}"
    elsif date.today?
      l date, format: '%H:%M'
    elsif date > Time.now.yesterday.beginning_of_day
      l date, format: "#{t(:yesterday)} %H:%M"
    elsif date > (Time.now - 7.days).beginning_of_day
      l date, format: '%A %H:%M'
    else
      l date, format: '%e %b %Y'
    end
  end

  def time_or_date(date)
    if date > Time.now.yesterday.beginning_of_day
      date.strftime('%H:%M')
    else
      l date, format: '%e %b %Y'
    end
  end

  def format_date(date, time: true)
    f = time ? '%H:%M &nbsp;  %e %b %Y' : '%e %b %Y'
    raw(localize(date, format: f))
  end

  def snippet(key, variables = {}, options = {}, &block)
    snippet = Snippet.find_by_key(key)

    if snippet.present?
      snippet_body = if snippet.v2.present?
                       ab_variant? ? snippet.v2 : snippet.body
                     else
                       snippet.body
                     end

      if snippet_body.present?
        html = snippet_body.to_s

        template = Liquid::Template.parse(html) # Parses and compiles the template
        raw template.render(variables.stringify_keys)
      end
    elsif block_given?
      html = capture(&block)
      Snippet.create(key: key, body: html) unless options[:do_not_create_missing]

      html
    else
      Snippet.create(key: key).body unless options[:do_not_create_missing]
    end
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
    t0 = Time.now

    yield

    t1 = Time.now

    Rails.logger.debug "TEMPLATE BENCHMARK '#{name}': #{t1 - t0}"
  end
end
