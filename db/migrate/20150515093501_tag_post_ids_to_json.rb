class TagPostIdsToJson < ActiveRecord::Migration
  def change
    Tag.transaction do
      Tag.connection.select_all('SELECT id, post_ids FROM tags').each do |tag|
        next if tag['post_ids'].blank?

        json = JSON.dump YAML.safe_load(tag['post_ids'])

        Tag.where(id: tag['id']).update_all post_ids: json
      end
    end
  end
end
