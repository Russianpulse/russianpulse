require 'rails_helper'

RSpec.feature 'Comments', type: :feature, js: false do
  let!(:post) { FactoryGirl.create(:post, title: 'Post title') }

  scenario 'Guest creates new comment for a post' do
    visit "/posts/#{post.id}"

    VCR.use_cassette :google_recaptcha do
      within('#comments_form') do
        fill_in 'comment[user_attributes][name]', with: 'George Bush'
        fill_in 'comment_comment', with: 'My private opinion'
        first('.btn-primary').click
      end
    end

    expect(page).to have_text('My private opinion')
    expect(page).to have_text('George Bush')
  end

  scenario 'Guest creates new comment for a post' do
    create :user, email: 'me@example.com', name: 'George Bush', password: 'secret123', password_confirmation: 'secret123'
    visit '/users/sign_in'
    fill_in 'Email', with: 'me@example.com'
    fill_in 'Password', with: 'secret123'
    click_on 'Sign in'

    visit "/posts/#{post.id}"

    within('#comments_form') do
      fill_in 'comment_comment', with: 'My private opinion'
      first('.btn-primary').click
    end

    expect(page).to have_text('My private opinion')
    expect(page).to have_text('George Bush')
  end
end
