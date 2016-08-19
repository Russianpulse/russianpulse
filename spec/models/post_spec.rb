require 'rails_helper'

RSpec.describe Post, :type => :model do
  describe '.published' do
    subject { Post.published }
    let!(:post) { FactoryGirl.create :post }
    let!(:post_blocked) { FactoryGirl.create :post, :blocked }
    it { is_expected.to include post }
    it { is_expected.not_to include post_blocked }
  end

  describe '.top' do
    subject { Post.top }

    before do
      @post = FactoryGirl.create :post
      @top_post = FactoryGirl.create :post, :top

      @commented_post = FactoryGirl.create :post, :commented
    end

    it { is_expected.not_to include @post }
    it { is_expected.to include @top_post }
    it { is_expected.to include @commented_post }
  end

  let(:post) { FactoryGirl.build :post }

  describe '#picture_url' do
    subject { post.picture_url }
    before { post.picture_url = 'http://example.com/pic.jpeg' }
    it { is_expected.to eq '//example.com/pic.jpeg' }
  end
end
