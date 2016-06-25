module Posts
  # Text-only posts widget
  class TextBlockCell < Cell::ViewModel
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::CaptureHelper
    include ApplicationHelper
    include CommentsHelper
    include PostsHelper
    include ActionView::Helpers::TranslationHelper

    def show
      @posts = model
      render
    end
  end
end
