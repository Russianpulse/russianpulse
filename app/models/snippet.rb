class Snippet < ApplicationRecord
  validates :key, uniqueness: true, presence: true
end
