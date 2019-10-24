require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'not_for scope' do
    subject { Comment.not_for(commentable) }
    let!(:commentable) { FactoryGirl.create :post }
    let!(:comment) { FactoryGirl.create :comment, commentable: commentable }
    let!(:another_commentable) { FactoryGirl.create :post }
    let!(:comment_for_another_commentable) { FactoryGirl.create :comment, commentable: another_commentable }

    it { is_expected.to include comment_for_another_commentable }
    it { is_expected.not_to include comment }
  end

  describe '.recent' do
    subject { Comment.recent }
    it { is_expected.to include create(:comment) }
    it { is_expected.not_to include create(:comment, :spam) }
  end
end
