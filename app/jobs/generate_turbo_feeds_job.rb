class GenerateTurboFeedsJob < ApplicationJob
  queue_as :default

  def perform
    mkdir
    File.open(Rails.root.join('public', 'yandex', 'turbo.xml'), 'w') do |f|
      f.write YandexTurboCell.call(posts).call(:show)
    end
  end

  private

  def mkdir
    FileUtils.mkdir_p Rails.root.join('public', 'yandex')
  end

  def posts
    Post.top.recent.limit(100) + Post.published.not_top.newer_than(2.days.ago)
  end
end
