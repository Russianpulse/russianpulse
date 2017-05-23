class FixTags < ActiveRecord::Migration[4.2]
  def change
    Tag.where.not(post_ids: nil).find_each do |tag|
      if tag.post_ids.is_a? String
        tag.post_ids = JSON.parse tag.post_ids
        tag.save!
      end
    end
  end
end
