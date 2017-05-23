class RemoveBodyAndSourceHtmlFromPosts < ActiveRecord::Migration[4.2]
  def change
    remove_column :posts, :body, :text
    remove_column :posts, :source_html, :text
  end
end
