class Podcasts::PodcastsController < ApplicationController
  def index
    @episodes = Episode.all
  end
end
