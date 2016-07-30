class RemoveBodyAndSourceHtmlFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :body, :text
    remove_column :posts, :source_html, :text
  end
end
