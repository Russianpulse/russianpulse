class RobotsController < ApplicationController
  layout false

  def index
    render template: "robots/index.txt.erb"
  end
end
