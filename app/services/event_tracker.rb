class EventTracker
  include Singleton

  delegate :pageview, :event, :social, :exception, :timing, :transaction, :transaction_item, to: :staccato, allow_nil: true

  def initialize
    @ga_id = Snippet.find_by(key: 'google_analytics_id').try(:body)
    return if Rails.env.test?

    @staccato = Staccato.tracker(@ga_id)
  end

  def track(category, action, label = nil, value = nil)
    return if Rails.env.test?

    Rails.logger.warn 'EventTracker.track is depricated'
    event(category: category, action: action, label: label, value: value, non_interactive: true)
  rescue Exception => e
    ExceptionNotifier.notify_exception e
  end

  def notify(_category, _action, _label = nil, _value = nil)
    return if Rails.env.test?
  rescue Exception => ex
    ExceptionNotifier.notify_exception ex
  end

  def track_and_notify(category, action, label = nil, value = nil)
    track(category, action, label, value)
    notify(category, action, label, value)
  end

  def self.method_missing(name, *args)
    instance.send(name, *args)
  end

  private

  attr_reader :staccato
end
