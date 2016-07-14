class RobotsController < ApplicationController
  layout false

  def index
    render template: "robots/index.txt.erb"
    expires_in(30.minutes, public: true)
  end
end
