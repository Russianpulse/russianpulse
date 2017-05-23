class AddBlockReasonToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :block_reason, :text
  end
end
