module UriHelper
  def host_from_url(url)
    URI(url).host
  rescue
    nil
  end

  def favicon_url(url)
    "//www.google.com/s2/favicons?domain=#{host_from_url(url)}"
  end

  def favicon_icon(url)
    image_tag favicon_url(url), width: 16, height: 16, alt: '', title: ''
  end

  def gravatar_url(email, args = {})
    # include MD5 gem, should be part of standard ruby install
    # require 'digest/md5'
    # create the md5 hash
    hash = Digest::MD5.hexdigest(email.downcase)

    # compile URL which can be used in <img src="RIGHT_HERE"...
    "//www.gravatar.com/avatar/#{hash}?s=#{args[:size] || 35}"
  end
end
