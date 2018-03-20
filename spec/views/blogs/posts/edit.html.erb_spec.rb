require 'rails_helper'

RSpec.describe "blogs/posts/edit", type: :view do
  before(:each) do
    @blogs_post = assign(:blogs_post, Blogs::Post.create!())
  end

  it "renders the edit blogs_post form" do
    render

    assert_select "form[action=?][method=?]", blogs_post_path(@blogs_post), "post" do
    end
  end
end
