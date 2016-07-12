class AddStreamToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :stream, :string, default: :inbox
  end
end
