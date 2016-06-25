class AddFriendlyParamToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :friendly_param, :string
  end
end
