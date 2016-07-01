class SchedulerJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    run_every 1.minute, UpdateBlogJob
    run_every 15.minutes, UpdateRatingJob
    run_every 1.hour, UpdatePostsPerHourJob
    run_every 1.hour, TopPostsSpiderJob
    run_every 3.hours, CleanupJob
    run_every 3.hours, TagsCleanupJob
    run_every 24.hours, TopPostsSpiderJob, "all"
    run_every 24.hours, RefreshSitemapJob
  end

  private

  def run_every(period, job_klass, *args)
    Rails.cache.fetch "schedulerjob##{job_klass}:#{args.to_json}", expires_in: period do
      job_klass.perform_later *args
    end
  end
end
