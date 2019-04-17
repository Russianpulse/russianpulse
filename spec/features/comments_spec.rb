require 'rails_helper'

RSpec.feature 'Comments', type: :feature, js: true, skip: true do
  let!(:post) { FactoryGirl.create(:post, title: 'Post title') }

  scenario 'Guest creates new comment for a post' do
    visit "/posts/#{post.id}"

    VCR.use_cassette :google_recaptcha do
      click_on 'Зарегистрироваться'

      fill_in 'Email', with: 'me@example.com'
      fill_in 'Имя', with: 'George Bush'
      fill_in 'Пароль', with: 'secret123'
      fill_in 'Подтверждение пароля', with: 'secret123'
      click_on 'Зарегистрироваться'

      open_email 'me@example.com'
      current_email.click_link 'Confirm my account'

      visit "/posts/#{post.id}"
      within('#comments_form') do
        fill_in 'comment_comment', with: 'My private opinion'
        first('.btn-primary').click
      end
    end

    expect(page).to have_text('My private opinion')
    expect(page).to have_text('George Bush')
  end
end
