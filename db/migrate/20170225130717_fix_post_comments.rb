class FixPostComments < ActiveRecord::Migration[5.0]
  def change
    Comment.where(commentable_type: 'Post').update_all(commentable_type: 'PostBase')
  end
end
