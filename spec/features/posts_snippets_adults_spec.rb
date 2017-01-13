require 'rails_helper'

RSpec.feature 'PostsSnippetsAdults', type: :feature do
  let(:post) { FactoryGirl.create(:post) }
  let(:post_path) { [post.blog.slug, post.created_at.year, post.created_at.month, post.created_at.day, post.id].join('/') }

  before do
    Snippet.create(key: :post_right_tower, body: '{% if adult != true %}ADS{% endif %}')
  end

  scenario 'when post has picture ads should be hidden' do
    post.update_columns(
      picture_url: 'http://example.com/pic.jpeg'
    )

    visit post_path
    expect(page).to have_text post.title
    expect(page).not_to have_text 'ADS'
  end

  scenario 'when post has no picture ads should be displayed' do
    post.update_columns(
      picture_url: nil
    )

    visit post_path
    expect(page).to have_text post.title
    expect(page).to have_text 'ADS'
  end
end
