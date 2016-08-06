class EventTracker
  include Singleton

  delegate *[
    :pageview, :event, :social, :exception, :timing,
    :transaction, :transaction_item
  ], to: :staccato, allow_nil: true

  attr_reader :slack_notifier

  def initialize
    @ga_id = Snippet.find_by(key: "google_analytics_id").try(:body)
    return if Rails.env.test?

    @staccato = Staccato.tracker(@ga_id)
    @slack_notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
  end

  def track(category, action, label=nil, value=nil)
    Rails.logger.warn 'EventTracker.track is deprocated'
    event(category: category, action: action, label: label, value: value, non_interactive: true)
  end

  def notify(category, action, label=nil, value=nil)
    slack_notifier.ping "#{category.to_s.titleize} #{action} #{label} #{value}"
  end

  def track_and_notify(category, action, label=nil, value=nil)
    track(category, action, label, value)
    notify(category, action, label, value)
  end

  def self.method_missing(name, *args)
    instance.send(name, *args)
  end

  private

  attr_reader :staccato
end
