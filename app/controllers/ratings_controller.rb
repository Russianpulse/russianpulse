class RatingsController < ApplicationController
  def posts
    days = params[:days] || 7
    @posts = Post.published.newer_than(days.to_i.days.ago).order("views DESC").limit(20)
  end
end
