module CommentsHelper
  def comment_path(comment)
    smart_post_path(comment.commentable, anchor: "comment_#{comment.id}")
  end

  def comment_url(comment)
    smart_post_url(comment.commentable, anchor: "comment_#{comment.id}")
  end

  def comments_link(commentable, options = {})
    return unless options[:without_comments]

    content_tag :span, class: (options[:class] || 'pull-right'), title: t(:discussion) do
      link_to smart_post_path(commentable, anchor: 'comments'), class: 'no-underline', data: { turbolinks: false } do
        glyphicon(:comment) + raw('&nbsp;')
      end
    end
  end
end
