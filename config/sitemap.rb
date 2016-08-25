# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "#{ENV['SSL'] ? 'https' : 'http'}://#{Rails.configuration.x.domain}"
SitemapGenerator::Interpreter.send :include, PostsHelper
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add about_path, changefreq: 'monthly', priority: 0.8
  add search_path, changefreq: 'monthly', priority: 0.8

  add posts_path, lastmod: Post.published.maximum(:created_at), changefreq: 'always', priority: 1
  add posts_path(top: 1), lastmod: Post.published.top.maximum(:created_at), changefreq: 'daily', priority: 1
  add rating_path, priority: 0.2
  add archive_path, lastmod: 1.day.ago, changefreq: 'monthly', priority: 0.5


  Blog.find_each do |blog|
    add blog_path(blog.slug), lastmod: blog.updated_at, changefreq: 'hourly', priority: 1
  end

  Post.published.find_each do |post|
    add smart_post_path(post), lastmod: post.updated_at, priority: 0.1, changefreq: 'monthly'
  end
end
