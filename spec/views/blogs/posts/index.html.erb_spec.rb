require 'rails_helper'

RSpec.describe "blogs/posts/index", type: :view do
  before(:each) do
    assign(:blogs_posts, [
      Blogs::Post.create!(),
      Blogs::Post.create!()
    ])
  end

  it "renders a list of blogs/posts" do
    render
  end
end
