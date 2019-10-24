require 'rails_helper'

RSpec.feature 'Search', type: :feature, js: false, pending: true do
  let!(:post) { FactoryGirl.create(:post, title: 'My fancy article') }

  scenario 'Type a word from post title and find it' do
    visit '/'

    fill_in 'Поиск', with: 'fancy'
    find('.test-search-input').native.send_keys :enter

    expect(page).to have_text('My fancy article')
  end
end
