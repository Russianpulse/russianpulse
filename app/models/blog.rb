class Blog < ActiveRecord::Base
  validates :title, :presence => true
  validates :slug, :presence => true
  validates :fetch_type, :inclusion => { :in => %w(net_http), :allow_blank => true }
end
