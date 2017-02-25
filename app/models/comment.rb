class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment

  belongs_to :commentable, polymorphic: true, touch: true, counter_cache: true

  scope :recent, -> { order('created_at DESC') }
  scope :not_for, ->(commentable) { where.not('commentable_type = ? AND commentable_id = ?', commentable.class.base_class, commentable.id) }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  # acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  validates :comment, presence: true
  validates :user, presence: true
end
