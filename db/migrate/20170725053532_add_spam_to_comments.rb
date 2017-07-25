class AddSpamToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :spam, :boolean
  end
end
