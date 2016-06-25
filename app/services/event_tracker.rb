class EventTracker
  include Singleton
  MAZAVR_ENGINE_GA_ID = "UA-59280793-5"

  delegate *[
    :pageview, :event, :social, :exception, :timing,
    :transaction, :transaction_item
  ], to: :staccato, allow_nil: true

  def initialize
    @ga_id = Snippet.find_by(key: "google_analytics_id").try(:body)
    @ga_id = @ga_id.present? ? @ga_id : MAZAVR_ENGINE_GA_ID

    @staccato = Rails.env.test? ? nil : Staccato.tracker(@ga_id)
  end

  # Deprecated
  # TODO: remove this method
  def track(category, action, label=nil, value=nil)
    event(category: category, action: action, label: label, value: value, non_interactive: true)
  end

  def self.method_missing(name, *args)
    instance.send(name, *args)
  end

  private

  attr_reader :staccato
end
