class ArchiveController < ApplicationController
  def index
  end

  def day
    @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)

    @posts = Post.includes(:blog).created_between(@date.beginning_of_day, @date.end_of_day).recent
  end
end
