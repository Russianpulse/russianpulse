class AddSourceHtmlToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :source_html, :text
  end
end
