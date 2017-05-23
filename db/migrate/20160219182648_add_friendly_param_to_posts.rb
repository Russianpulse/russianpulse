class AddFriendlyParamToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :friendly_param, :string
  end
end
