require 'rails_helper'

RSpec.describe Blog, type: :model do
  let(:blog) { FactoryGirl.create :blog }

  describe 'health_status' do
    subject { blog.health_status }

    it { is_expected.to eq 0 }

    context 'when 3 times failed and 7 times succeded' do
      before do
        3.times { blog.failed_to_check! }
        7.times { blog.checked! }
      end

      it { is_expected.to eq 3 }
    end
  end

  describe 'recent_fetches' do
    subject { blog.recent_fetches }
    before { 15.times { blog.checked! } }

    its(:size) { is_expected.to eq 10 }
  end

  describe '#failed_to_check!' do
    context 'when blog has invalid post' do
      let(:invalid_post_attributes) { { title: '' } }

      before do
        blog.posts.build invalid_post_attributes
      end

      it 'should not raise' do
        blog.failed_to_check!
      end
    end
  end
end
