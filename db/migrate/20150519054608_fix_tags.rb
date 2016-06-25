class FixTags < ActiveRecord::Migration
  def change
    Tag.where.not(:post_ids => nil).find_each do |tag|

      if tag.post_ids.is_a? String
        tag.post_ids = JSON.parse tag.post_ids
        tag.save!
      end
    end
  end
end
