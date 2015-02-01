require 'open-uri'

class ImportPostJob
  include SuckerPunch::Job
  workers 8

  def perform(domain, blogs, origin_id)
    ActiveRecord::Base.connection_pool.with_connection do
      post_attributes = parse_jsonp open("http://#{domain}/export/post.json?id=#{origin_id}").read

      if Post.exists? origin_id
        post_attributes.delete("id")
      end

      post = Post.new post_attributes

      post.blog = blogs[post_attributes["blog_id"]]

      post.save!

      print "."
    end
  end
end

def import_mazavr(domain, slug)
  blog_ids = parse_jsonp open("http://#{domain}/export/blogs.json").read

  blogs_by_origin_id = {}

  blog_ids.each do |blog_origin_id|
    blog_attributes = parse_jsonp open("http://#{domain}/export/blog.json?id=#{blog_origin_id}").read

    blog_attributes.delete("id")

    if Blog.where(slug: blog_attributes["slug"]).exists?
      blog_attributes["slug"] += "-#{slug}"
    end

    blog_attributes["category"] = slug

    blog = Blog.create! blog_attributes

    blogs_by_origin_id[blog_origin_id] = blog

    print "b"
  end

  post_ids = parse_jsonp open("http://#{domain}/export/posts.json").read

  n = 0

  post_ids.each do |post_origin_id|
    ImportPostJob.perform_async(domain, blogs_by_origin_id, post_origin_id)

    n += 1
  end
end

def parse_jsonp(jsonp)
  json = jsonp.remove(/^[^(]+\(/).remove(/\)$/)

  JSON.parse json
end

namespace :charybd do
  namespace :import do
    desc "Import blogs and posts from finance charybd"
    task finance: :environment do
      import_mazavr "mazavr.herokuapp.com", "finance"

      while true do
        sleep 1
      end
    end

    desc "Import blogs and posts from tech charybd"
    task tech: :environment do
      import_mazavr "tech.charybd.com", "tech"

      while true do
        sleep 1
      end
    end

    desc "Import blogs and posts from health charybd"
    task health: :environment do
      import_mazavr "health.charybd.com", "health"

      while true do
        sleep 1
      end
    end
  end
end
