class RedirectsController < ApplicationController
  def bye
    @url = params[:url]

    days = params[:days] || 7
    @posts = Post.newer_than(days.to_i.days.ago).order('views DESC').limit(20)

    expires_in(30.minutes, public: true)
  end
end
