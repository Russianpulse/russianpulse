class SluggerJob < ActiveJob::Base
  queue_as :default

  # Запоминаем короткую ссылку на источник, откуда будем восстанвливать
  def perform(*_args)
    counter = 0

    begin
      Post.where(slug_id: nil).find_each do |post|
        post.update_attribute :slug_id, Archive.new.slug_id_for_post(post)
        counter += 1
      end
    rescue StandardError => ex
      EventTracker.track 'Jobs', 'Slugs added', nil, counter
      raise ex
    end
  end
end
