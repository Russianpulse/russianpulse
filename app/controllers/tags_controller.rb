class TagsController < ApplicationController
  def show
    @tag = Tag.find_by(slug: params[:tag].strip.downcase)
    raise ActiveRecord::RecordNotFound if @tag.blank?

    @posts = @tag.posts.order('created_at DESC').limit(12)
    @posts = @posts.older_than(Time.at(params[:before].to_f)) if params[:before].present?

    expires_in(30.minutes, public: true)
  end
end
