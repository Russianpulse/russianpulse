class Admin::HealthController < ApplicationController
  def index
    @blogs = Blog.all
  end
end
