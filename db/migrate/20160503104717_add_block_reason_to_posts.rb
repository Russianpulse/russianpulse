class AddBlockReasonToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :block_reason, :text
  end
end
