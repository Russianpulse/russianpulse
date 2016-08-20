class CommentsMailer < ApplicationMailer
  add_template_helper PostsHelper
  add_template_helper CommentsHelper

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.comments_mailer.created.subject
  #
  def created(comment, user)
    @comment = comment
    @user = user
    @author = comment.user
    @post_title = comment.commentable.title

    mail to: user.email, subject: "#{@author.name} ответил на Ваш комментарий"
  end
end
