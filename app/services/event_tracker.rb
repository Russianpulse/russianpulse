class EventTracker
  include Singleton

  delegate *[
    :pageview, :event, :social, :exception, :timing,
    :transaction, :transaction_item
  ], to: :staccato, allow_nil: true

  def initialize
    @ga_id = Snippet.find_by(key: "google_analytics_id").try(:body)
    return if @ga_id.blank?

    @staccato = Rails.env.test? ? nil : Staccato.tracker(@ga_id)
  end

  def self.method_missing(name, *args)
    return if staccato.blank?
    return if Rails.env.test?

    instance.send(name, *args)
  end

  private

  attr_reader :staccato
end
