require 'timeout'

class UpdatePodcastJob < UpdateBlogJob
  module PodcastEntry
    # youtube podcast feed is parsed as Rss, not as Podcast,
    # so it has no .enclosure method
    def enclosures
      [image]
    end
  end

  def entry_to_post(entry)
    entry.singleton_class.send(:include, PodcastEntry)

    post = Episode.new super.attributes.merge(type: 'Episode')
    post.enclosures = entry.enclosures

    post
  end
end
