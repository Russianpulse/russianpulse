class Podcasts::PodcastsController < ApplicationController
  def index
    @episodes = Episode.includes(:podcast).order('created_at DESC').limit(4)
    @episodes = @episodes.older_than(Time.at(params[:before].to_f)) if params[:before].present?
  end
end
