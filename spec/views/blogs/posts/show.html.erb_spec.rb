require 'rails_helper'

RSpec.describe "blogs/posts/show", type: :view do
  before(:each) do
    @blogs_post = assign(:blogs_post, Blogs::Post.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
