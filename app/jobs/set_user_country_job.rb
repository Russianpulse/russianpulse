class SetUserCountryJob < ApplicationJob
  queue_as :low

  DEFAULT_COUNTRY_CODE = 'ru'.freeze
  RUSSIA_COUNTRY_CODE = 'ru'.freeze

  def perform(user)
    @user = user

    return unless country_update_required?

    user.update(country_code: country_code(user.current_sign_in_ip.to_s))
  end

  private

  def country_update_required?
    return true if @user.country_code.blank?

    @user.last_sign_in_ip != @user.current_sign_in_ip
  end

  def country_code(ip)
    data = JSON.parse open("http://freegeoip.net/json/#{ip}").read
    country_code = data['country_code'].downcase.presence || DEFAULT_COUNTRY_CODE

    return RUSSIA_COUNTRY_CODE if data['region_name'] == 'Republic of Crimea'

    country_code
  rescue StandardError
    DEFAULT_COUNTRY_CODE
  end
end
