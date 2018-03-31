require 'rails_helper'

RSpec.feature 'Comments', type: :feature, js: true do
  let!(:post) { FactoryGirl.create(:post, title: 'Post title') }

  scenario 'Guest creates new comment for a post' do
    visit "/posts/#{post.id}"

    expect(page).to have_text('Post title')

    VCR.use_cassette :google_recaptcha do
      within('#comments_form') do
        fill_in 'Email', with: 'me@example.com'
        fill_in 'comment[user_attributes][name]', with: 'George Bush'

        fill_in 'comment_comment', with: 'My private opinion'

        first('.btn-primary').click
      end
    end

    expect(page).to have_text('My private opinion')
    expect(page).to have_text('George Bush')
  end
end
