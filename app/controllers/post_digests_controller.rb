class PostDigestsController < ApplicationController
  def show
    @post_digest = PostDigest.find_by slug: params[:slug]
    raise ActiveRecord::RecordNotFound if @post_digest.blank?

    @posts = @post_digest.posts.order("created_at DESC")
  end
end
