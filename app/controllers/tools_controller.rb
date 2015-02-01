class ToolsController < ApplicationController
  def cleanup
    if params[:html].present?
      b = Blog.new :text_cleanup_rules => params[:rules]
      @result = b.cleanup_html(params[:html])
    end
  end

  def index
  end
end
