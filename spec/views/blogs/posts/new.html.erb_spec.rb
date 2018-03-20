require 'rails_helper'

RSpec.describe "blogs/posts/new", type: :view do
  before(:each) do
    assign(:blogs_post, Blogs::Post.new())
  end

  it "renders new blogs_post form" do
    render

    assert_select "form[action=?][method=?]", blogs_posts_path, "post" do
    end
  end
end
