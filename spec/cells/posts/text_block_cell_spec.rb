require 'rails_helper'

describe Posts::TextBlockCell, type: :cell do
  include Cell::Testing
  controller WelcomeController

  let(:posts) { (1..6).to_a.map { FactoryGirl.create(:post) } }
  subject { cell('posts/text_block', posts).call(:show) }

  it 'should include all posts' do
    posts.each do |post|
      is_expected.to include post.title
    end
  end

  context 'post has comments' do
    let(:posts) { (1..6).to_a.map { FactoryGirl.create(:post, :commented) } }
    xit { is_expected.to include 'comment' }
  end
end
