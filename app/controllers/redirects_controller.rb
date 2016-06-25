class RedirectsController < ApplicationController
  def bye
    @url = params[:url]

    @article = Readability::Document.new(page_html, attributes: %w[src href], remove_empty_nodes: false)

    @image = article_image

    days = params[:days] || 7
    @posts = Post.newer_than(days.to_i.days.ago).order("views DESC").limit(20)
  end

  private

  def page_html
    Rails.cache.fetch("goto##{@url}") do
      open(@url).read
    end
  end

  def article_image
    Rails.cache.fetch("goto##{@url}#image") do
      @article.images.first
    end
  end

end
