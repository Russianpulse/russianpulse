require 'rails_helper'

RSpec.feature 'Blogs Index', type: :feature, js: false do
  let!(:blog) { create :blog }

  scenario 'Guests opens /blogs page and can see a blog' do
    visit '/blogs'
    expect(page).to have_text(blog.title)
  end
end
