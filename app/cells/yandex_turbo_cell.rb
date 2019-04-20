class YandexTurboCell < BaseCell
  def show
    @posts = model
    render
  end

  def ssl?
    ENV['SSL'] == 'true'
  end

  def protocol
    ssl? ? :https : :http
  end

  def turbo_content(html)
    html
  end

  def post_url(post)
    "#{protocol}://#{Rails.configuration.x.domain}/posts#{post.id}"
  end
  
  def ab_variant?
    false
  end
end
