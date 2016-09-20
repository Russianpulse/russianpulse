module CommentsHelper
  def comment_path(comment)
    smart_post_path(comment.commentable, anchor: "comment_#{comment.id}")
  end

  def comment_url(comment)
    smart_post_url(comment.commentable, anchor: "comment_#{comment.id}")
  end

  def comments_link(commentable, options={})
    return if (commentable.comments_count <= 0) && !options[:without_comments]

    link_to smart_post_path(commentable, anchor: 'comments'), class: 'mdl-button mdl-js-button mdl-button--icon mdl-js-ripple-effect', title: t(:discussion) do
      concat content_tag :i, :comment, class: 'material-icons'
    end
  end
end
