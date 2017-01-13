require 'rails_helper'

RSpec.describe 'Blogs', type: :request do
  let(:blog) { FactoryGirl.create :blog, slug: 'blog-1' }

  describe 'GET /blog-1' do
    it 'works!' do
      get blog_path(blog.slug)
      expect(response).to have_http_status(200)
    end
  end
end
