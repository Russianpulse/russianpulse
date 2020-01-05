require 'rails_helper'

RSpec.feature 'Mark comment as spam', type: :feature, js: false, skip: true do
  let!(:post) { FactoryGirl.create(:post, title: 'Post title') }
  let!(:comment) { FactoryGirl.create :comment, commentable: post, comment: 'spam message' }
  let!(:admin) { FactoryGirl.create :user, :admin }

  scenario 'Admin marks comment and its content is hidden' do
    login_as(admin)

    visit "/posts/#{post.id}"

    within "#comment-#{comment.id}" do
      expect(page).to have_content 'spam message'

      find('.mark-as-spam').click
    end

    within "#comment-#{comment.id}" do
      expect(page).not_to have_content 'spam message'
      expect(page).to have_content 'Marked as SPAM'
    end

    expect(comment.user.reload).to be_flagged
  end
end
