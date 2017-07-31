module Posts
  # Text-only posts widget
  class TextBlockCell < BaseCell
    def show
      @posts = model
      render
    end
  end
end
