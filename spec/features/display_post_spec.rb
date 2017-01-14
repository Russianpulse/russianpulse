require 'rails_helper'

RSpec.feature 'Display Post', type: :feature do
  let!(:post) { create :post, source_url: 'http://example.com/some/path' }

  scenario 'open post page and can see a post text' do
    visit post_path(post.blog, 2014, 1, 2, post.id)
    expect(page).to have_text(post.title)

    expect(page).to have_css('.source-url-host', text: 'example.com')
  end
end
