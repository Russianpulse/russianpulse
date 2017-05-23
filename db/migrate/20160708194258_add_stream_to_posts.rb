class AddStreamToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :stream, :string, default: :inbox
  end
end
