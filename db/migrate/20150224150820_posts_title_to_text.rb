class PostsTitleToText < ActiveRecord::Migration
  def change
    change_column :posts, :title, :text
  end
end
