# :nocov:
class CleanupJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    cleanup_blocked if need_cleanup?
    smart_cleanup if need_cleanup?
    cleanup_hard if need_cleanup?
  end

  private

  def cleanup_blocked
    Post.where('blocked_at < ?', 6.hours.ago)
  end

  def cleanup_hard
    obj = Post.unpopular.limit(space_needed - space_available).destroy_all.size
    EventTracker.track_and_notify('Jobs', 'Cleanup hard', nil, obj.size)
  end

  def need_cleanup?
    space_needed > space_available
  end

  def space_available
    Rails.configuration.x.cleanup_posts_limit - Post.count
  end

  def space_needed
    # потенциальная мощность
    posts_per_day_max = Blog.sum(:posts_per_hour) * 24

    recent_created_at = Post.maximum(:created_at) || Time.zone.now

    # сколько было фактически за последние сутки
    posts_per_day_actual = Post.newer_than(recent_created_at - 1.day).count

    (posts_per_day_max + posts_per_day_actual) / 2
  end

  module SmartCleanup
    def divide_period_into_parts(from, to, n = 1)
      periods = [[from, to]]

      n.times do
        new_periods = []

        periods.each_with_index do |period, _index|
          from = period[0]
          to = period[1]

          m = median(from, to)

          new_periods << [from, m]
          new_periods << [m, to]
        end

        periods = new_periods
      end

      periods
    end

    MAX_ITERATIONS = 50
    MIN_ERROR_TRUSTED = 0.01

    def median(from, to)
      from = from.to_f
      to = to.to_f

      # область поиска
      median_from = from
      median_to = to

      current = -> { (median_from + median_to) / 2 }
      count_older = -> { Post.created_between(Time.at(from).in_time_zone, Time.at(current.call).in_time_zone).count }
      count_newer = -> { Post.created_between(Time.at(current.call).in_time_zone, Time.at(to).in_time_zone).count }
      error = -> { (count_older.call - count_newer.call).abs.to_f / ((count_older.call + count_newer.call).abs / 2) }

      i = 0
      loop do
        break if i > MAX_ITERATIONS
        break if error.call < MIN_ERROR_TRUSTED

        if count_older.call < count_newer.call
          median_from = current.call
        else
          median_to = current.call
        end

        i += 1
      end

      Time.at(current.call).in_time_zone
    end

    # делим весь период на 16 частей
    # очищаем каждый период, кроме самого последнего
    def smart_cleanup
      count = 0

      delete_in_each_period = ((space_needed - space_available).to_f / 15).round
      periods = divide_period_into_parts(Post.minimum(:created_at), Post.maximum(:created_at), 4)
      periods.pop

      from = periods[0][0]
      to = periods[-1][1]
      obj = Post.where(views: 0).limit(space_needed - space_available).created_between(from, to).destroy_all.size
      count += obj.size
      EventTracker.track('Jobs', 'Cleanup unused', "#{from} - #{to}", obj.size)

      return unless need_cleanup?

      delete_in_each_period = ((space_needed - space_available).to_f / 15).round
      divide_period_into_parts(Post.minimum(:created_at), Post.maximum(:created_at), 4)[0..-2].each do |period|
        obj = cleanup_period(period[0], period[1], delete_in_each_period)
        count += obj.size
        EventTracker.track('Jobs', 'Cleanup smart', "#{period[0]} - #{period[1]}", obj.size)
      end

      count
    end

    def cleanup_period(from, to, limit)
      obj = Post.created_between(from, to).unpopular.limit(limit).destroy_all
    end
  end

  include SmartCleanup
end
# :nocov:
