class PostsTitleToText < ActiveRecord::Migration[4.2]
  def change
    change_column :posts, :title, :text
  end
end
