require 'net/http'

class CacheHeaterJob < ApplicationJob
  queue_as :default

  def perform(path)
    url = "http://#{Rails.configuration.x.domain}#{path}"
    uri = URI(url)

    req = Net::HTTP::Get.new(uri)

    req['Cookie'] = "#{ENV['CACHE_REVALIDATE_SECRET_COOKIE']}=1"

    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

    "#{path}##{Time.now.in_time_zone}"
  end
end
