class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :check_subdomain
  before_filter :schedule_jobs unless lambda { Rails.env.test? }
  before_action :set_locale

  helper_method :ab_variant?

  rescue_from StandardError do |ex|
    logger.error ex
    NewRelic::Agent.notice_error(ex)
    render "errors/exception", :status => 500
  end if Rails.env.production?

  rescue_from ActiveRecord::RecordNotFound do
    render "errors/not_found", :status => 404
  end

  before_filter :load_ab_test

  private
   
  def set_locale
    if rails_admin?
      I18n.locale = :en
    else
      I18n.locale = user_locale || ENV['DEFAULT_LOCALE'] || :en
    end
  end

  def rails_admin?
    self.class.to_s.split('::').first == 'RailsAdmin'
  end

  def user_locale
    cookies[:locale] = params[:locale] if params[:locale].present?
    cookies[:locale]
  end

  def ab_variant?
    params[:v] == "2"
  end

  def load_ab_test
    AbTest.find_each do |ab_test|
      if request.path.match(ab_test.path)
        @ab_test = ab_test
        break
      end
    end

  rescue StandardError => ex
    logger.error ex
  end

  def check_subdomain
    if Rails.configuration.x.domain && Rails.env.production? && request.host != Rails.configuration.x.domain
      redirect_to request.url.sub(request.host, Rails.configuration.x.domain)
    end
  end

  def schedule_jobs
    SchedulerJob.perform_later
  end

  def ga_event(args)
    session[:ga_events] ||= []

    session[:ga_events] << {
      category: args[:category], 
      action: args[:action],
      label: args[:label],
      value: args[:value],
      interaction: args[:interaction],
    }
  end

  def verify_recaptcha
    uri = URI('https://www.google.com/recaptcha/api/siteverify')
    res = Net::HTTP.post_form(uri, secret: ENV['RECAPTCHA_PRIVATE_KEY'], response: params['g-recaptcha-response'])
    JSON.parse(res.body)["success"]
  end
end
