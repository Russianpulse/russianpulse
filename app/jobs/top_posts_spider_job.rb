class TopPostsSpiderJob < ActiveJob::Base
  queue_as :default

  def perform(mode="recent")
    case mode.to_s
    when "all"
      (Post.minimum(:created_at).to_i..Time.now.to_i).step(1.day).each do |from| 
        from = Time.at(from).beginning_of_day
        to = from.end_of_day
        set_top_between(from, to)
      end
    when "recent"
      to = Post.maximum(:created_at) || Time.zone.now

      from = to - 1.day

      set_top_between(from, to)
    end
  end

  def set_top_between(from, to)
    Post.created_between(from, to).update_all top: false

    # только 5 самых популярных помечаем как top
    Post.created_between(from, to).limit(ENV["MAX_TOP_POSTS"] || 5).order("views DESC").update_all top: true
  end
end
