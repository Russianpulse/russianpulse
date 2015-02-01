class BlogView
  def initialize(blog)
    @blog = blog
  end

  def favicon_url
    "http://www.google.com/s2/favicons?domain=#{URI(posts.first.try(:source_url) || "http://#{Rails.configuration.x.domain}").host}"
  end

  private

  def method_missing(method, *args, &block)
    @blog.send(method, *args, &block)
  end
end
