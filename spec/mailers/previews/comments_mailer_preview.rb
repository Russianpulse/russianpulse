# Preview all emails at http://localhost:3000/rails/mailers/comments_mailer
class CommentsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/comments_mailer/created
  def created
    CommentsMailer.created Comment.last, User.last
  end

end
