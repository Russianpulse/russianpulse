class Comment < ApplicationRecord
  include ActsAsCommentable::Comment
  acts_as_votable

  belongs_to :commentable, polymorphic: true, counter_cache: true, touch: true

  scope :recent, -> { where(spam: [nil, false]).order('created_at DESC') }
  scope :not_for, ->(commentable) { where.not('commentable_type = ? AND commentable_id = ?', commentable.class.base_class, commentable.id) }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  # acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  validates :comment, presence: true
  validates :user, presence: true

  def comment
    if spam?
      I18n.translate('comments.marked_as_spam')
    else
      self[:comment]
    end
  end

  def rating
    weighted_score
  end
end
