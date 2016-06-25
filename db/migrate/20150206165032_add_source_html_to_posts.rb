class AddSourceHtmlToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :source_html, :text
  end
end
