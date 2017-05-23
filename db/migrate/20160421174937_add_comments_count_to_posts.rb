class AddCommentsCountToPosts < ActiveRecord::Migration[4.2]
  def up
    add_column :posts, :comments_count, :integer, default: 0, null: false
    add_index :posts, :comments_count

    Post.reset_column_information

    Post.where(id: post_ids).find_each do |post|
      post.update_column :comments_count, post.comments.count
    end
  end

  def down
    remove_column :posts, :comments_count
  end

  private

  def post_ids
    Comment.where(commentable_type: 'Post').group(:commentable_id).pluck(:commentable_id)
  end
end
