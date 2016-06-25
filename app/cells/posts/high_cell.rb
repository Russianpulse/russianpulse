module Posts
  # Post widget with picture
  class HighCell < Cell::ViewModel
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::CaptureHelper
    include ApplicationHelper
    include CommentsHelper
    include PostsHelper
    include ActionView::Helpers::TranslationHelper

    def show
      @post = model
      render
    end
  end
end
