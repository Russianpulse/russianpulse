class AddV2ToSnippets < ActiveRecord::Migration[4.2]
  def change
    add_column :snippets, :v2, :text
  end
end
