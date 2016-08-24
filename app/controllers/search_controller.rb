class SearchController < ApplicationController
  def index
    if params[:q].present?
      @posts = find_posts(params[:q])
    else
      @posts = Post.none
    end
  end

  private

  def find_posts(q)
    Post
      .where("title ILIKE ?", "%#{q}%")
      .where("body ILIKE ?", "%#{q}%")
      .where("tags_list ILIKE ?", "%#{q}%")
      .limit(30).recent
  end
end
