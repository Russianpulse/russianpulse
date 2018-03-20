require 'rails_helper'

RSpec.describe "Blogs::Posts", type: :request do
  describe "GET /blogs_posts" do
    it "works! (now write some real specs)" do
      get blogs_posts_path
      expect(response).to have_http_status(200)
    end
  end
end
