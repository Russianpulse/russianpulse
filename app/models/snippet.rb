class Snippet < ActiveRecord::Base
  validates :key, uniqueness: true, presence: true
end
