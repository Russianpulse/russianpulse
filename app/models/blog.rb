class Blog < BlogBase
  has_many :authors, class_name: 'BlogUser'
end
