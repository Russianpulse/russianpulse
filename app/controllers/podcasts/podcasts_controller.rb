class Podcasts::PodcastsController < ApplicationController
  def index
    @episodes = Episode.includes(:podcast).order('created_at DESC').limit(12)
    @episodes = @episodes.older_than(Time.zone.at(params[:before].to_f)) if params[:before].present?
  end
end
