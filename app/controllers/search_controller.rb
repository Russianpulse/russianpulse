class SearchController < ApplicationController
  def index
    @posts = if params[:q].present?
               find_posts(params[:q])
             else
               Post.none
             end
  end

  private

  def find_posts(q)
    Post.where('title ILIKE ? OR tags_list ILIKE ?', "%#{q}%", "%#{q}%")
        .limit(30).recent.published
  end
end
