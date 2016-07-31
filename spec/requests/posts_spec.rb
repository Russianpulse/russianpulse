require 'rails_helper'

RSpec.describe "Posts", type: :request do
  include PostsHelper

  describe "GET /" do
    context 'when no posts' do
      before { get root_path }
      it { expect(response).to have_http_status(200) }
    end

    context 'when posts exist' do
      before do
        10.times { FactoryGirl.create(:post) }
        3.times { FactoryGirl.create(:post, :top) }
        featured_blog = FactoryGirl.create :blog, :featured
        10.times { FactoryGirl.create(:post, blog: featured_blog) }
      end
      before { get root_path }

      it { expect(response).to have_http_status(200) }
    end
  end

  describe "GET /recent" do
    let!(:post) { FactoryGirl.create :post }
    before { get posts_path }
    it { expect(response).to have_http_status(200) }

    context 'atom' do
      before { get posts_path(format: :atom) }
      it { expect(response).to have_http_status(200) }
    end
  end

  describe "GET smart_post_path" do
    let!(:post) { FactoryGirl.create :post }
    before { get smart_post_path(post) }
    it { expect(response).to have_http_status(200) }
  end
end

