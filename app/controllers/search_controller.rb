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
    Post.where("title ILIKE ? OR tags_list ILIKE ?", "%#{q}%", "%#{q}%")
        .limit(30).recent
  end
end
