class ImageFinderJob < ActiveJob::Base
  queue_as :default

  def perform(post)
    doc = Nokogiri::HTML::DocumentFragment.parse(post.body)

    doc.css('img').each do |img|
      size = FastImage.size img['src']

      next if size.nil?

      if size.min > 300
        post.update_attribute :picture_url, img['src']
        break
      end
    end
  end
end
