# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Snippets

%w(
  about
  below_article
  below_article_text
  below_futher_readings
  below_trending
  bottom
  bottom_menu
  comments
  css_styles
  favicon_url
  google_analytics_id
  head
  logo
  main_page_teaser
  meta_title
  not_found
  search
  site_name
  something_goes_wrong
  teaser_body
  teaser_title
).each do |key|
  Snippet.find_or_create_by(key: key)
end

unless Blog.exists?(slug: "archive")
  Blog.create(:title => "Archive", :slug => "archive")
end

