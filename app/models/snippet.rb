class Snippet < ApplicationRecord
  validates :key, uniqueness: true, presence: true

  def self.find_by_key(key)
    cache.fetch(key, expires_in: 60) { find_by key: key }
  end

  private

  def self.cache
    Rails.configuration.x.cache
  end
end
