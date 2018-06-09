class BaseCell < Cell::ViewModel
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::CaptureHelper
  include ApplicationHelper
  include CommentsHelper
  include PostsHelper
  include SnippetsHelper
  include ActionView::Helpers::TranslationHelper
  include Devise::Controllers::Helpers
end
