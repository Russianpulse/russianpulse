class RedirectsController < ApplicationController
  def bye
    @url = params[:url]

    if @url.match /goo\.gl/
      days = params[:days] || 7
      @posts = Post.newer_than(days.to_i.days.ago).order('views DESC').limit(20)
    else
      render html: 'Not found', status: 404
    end
  end
end
