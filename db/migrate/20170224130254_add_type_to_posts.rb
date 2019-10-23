class AddTypeToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :type, :string
    PostBase.update_all(type: 'Post') if defined?(PostBase)
  end
end
