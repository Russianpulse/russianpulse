class BlogUser < ApplicationRecord
  self.table_name = :blogs_users
  belongs_to :blog
  belongs_to :user
end
