class SetUserCountryJob < ApplicationJob
  queue_as :low

  DEFAULT_COUNTRY_CODE = 'ru'.freeze

  def perform(user)
    @user = user

    if country_update_required?
      user.update_attribute(:country_code, country_code(user.current_sign_in_ip.to_s))
    end
  end

  private

  def country_update_required?
    return true if @user.country_code.blank?

    @user.last_sign_in_ip != @user.current_sign_in_ip
  end

  def country_code(ip)
    data = JSON.parse open("http://freegeoip.net/json/#{ip}").read
    data['country_code'].downcase.presence || DEFAULT_COUNTRY_CODE
  rescue
    DEFAULT_COUNTRY_CODE
  end
end
