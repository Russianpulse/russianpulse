class AddV2ToSnippets < ActiveRecord::Migration
  def change
    add_column :snippets, :v2, :text
  end
end
