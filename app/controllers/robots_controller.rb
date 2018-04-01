class RobotsController < ApplicationController
  layout false

  def index
    render template: 'robots/index.txt.erb'
    expires_in(30.minutes, public: true)
  end

  def sitemap
    redirect_to "http://#{ENV['S3_BUCKET_NAME']}.s3.amazonaws.com/sitemaps/sitemap.xml.gz"
  end
end
