require 'rails_helper'

describe Posts::HighCell, type: :cell do
  include Cell::Testing
  controller WelcomeController

  let(:post) { FactoryGirl.create(:post) }
  subject { cell('posts/high', post).call(:show) }

  it { is_expected.to include post.title }

  context 'post has comments' do
    let(:post) { FactoryGirl.create(:post, :commented) }
    it { is_expected.to include 'comment' }
  end
end
