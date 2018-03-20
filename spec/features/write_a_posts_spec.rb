require 'rails_helper'

RSpec.feature "WriteAPosts", type: :feature do
  scenario 'User can write a post' do
    visit '/editor/posts'

    click_on 'Новая статья'

    fill_in 'Заголовок', with: 'Новая статья'
  end
end
