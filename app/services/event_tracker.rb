class EventTracker
  include Singleton

  delegate *[
    :pageview, :event, :social, :exception, :timing,
    :transaction, :transaction_item
  ], to: :staccato, allow_nil: true

  def initialize
    @ga_id = Snippet.find_by(key: "google_analytics_id").try(:body)
    return if @ga_id.blank?
    return if Rails.env.test?

    @staccato = Staccato.tracker(@ga_id)
  end

  # Deprecated
  # TODO: remove this method
  def track(category, action, label=nil, value=nil)
    Rails.logger.warn 'EventTracker.track is deprocated'
    event(category: category, action: action, label: label, value: value, non_interactive: true)
  end

  def self.method_missing(name, *args)
    instance.send(name, *args)
  end

  private

  attr_reader :staccato
end
