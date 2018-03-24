require 'timeout'

class UpdatePodcastJob < UpdateBlogJob
  module PodcastEntry
  end

  def entry_to_post(entry)
    entry.singleton_class.send(:include, PodcastEntry)

    post = Episode.new super.attributes.merge(type: 'Episode')
    post.enclosures = entry.links

    post
  end
end
