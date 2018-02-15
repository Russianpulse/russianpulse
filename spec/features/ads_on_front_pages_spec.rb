require 'rails_helper'

RSpec.feature "AdsOnFrontPages", type: :feature do
  scenario 'we have ads and it is disaplyed on front page' do
    ads = create :post, :ads

    visit '/'

    expect(page).to have_content ads.title
  end
end
