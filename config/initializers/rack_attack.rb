# https://github.com/kickstarter/rack-attack
#
# Block suspicious requests for '/etc/password' or wordpress specific paths.
# After 3 blocked requests in 10 minutes, block all requests from that IP for 5 minutes.
Rack::Attack.blocklist('fail2ban pentesters') do |req|

  # `filter` returns truthy value if request fails, or if it's from a previously banned IP
  # so the request is blocked
  Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 5.minutes) do
    # The count for the IP is incremented if the return value is truthy
    req.path.include?('wp-admin') ||
    req.path.include?('wp-login')
  end
end


Rack::Attack.throttle('limit gotos', limit: 5, period: 60) do |req|
  if req.path.start_with? '/goto'
    req.ip
  end
end

