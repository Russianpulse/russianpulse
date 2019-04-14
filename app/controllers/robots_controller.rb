class RobotsController < ApplicationController
  layout false

  def index
    render template: 'robots/index.txt.erb'
  end

  def sitemap
    redirect_to "https://#{ENV['S3_BUCKET_NAME']}.s3.amazonaws.com/sitemaps/sitemap.xml.gz"
  end
end
