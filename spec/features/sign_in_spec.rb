require 'rails_helper'

RSpec.feature 'Sign in', type: :feature, js: false, skip: true do
  let!(:user) { create :user, email: 'me@example.com', name: 'Roger Wilco', password: 'secret123', password_confirmation: 'secret123' }

  scenario 'As registered user I can log in' do
    # When
    visit '/'
    within '.navbar' do
      click_on 'Sign in'
    end

    # And
    within '.container--main' do
      fill_in 'Email', with: 'me@example.com'
      fill_in 'Password', with: 'secret123'
      click_on 'Sign in'
    end

    # Then
    visit '/'
    expect(page).to have_text('Roger Wilco')
  end
end
