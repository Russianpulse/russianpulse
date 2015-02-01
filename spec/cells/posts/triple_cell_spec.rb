require 'rails_helper'

describe Posts::TripleCell, type: :cell do
  include Cell::Testing
  controller WelcomeController

  let(:posts) { (1..3).to_a.map { FactoryGirl.create(:post) } }
  subject { cell('posts/triple', posts).call(:show) }

  it 'should include all posts' do
    posts.each do |post|
      is_expected.to include post.title
    end
  end

  context 'post has comments' do
    let(:posts) { (1..3).to_a.map { FactoryGirl.create(:post, :commented) } }
    it { is_expected.to include 'comment' }
  end
end
