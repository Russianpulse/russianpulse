require 'rails_helper'

describe CommentersCell, type: :cell do
  include Cell::Testing
  controller WelcomeController

  let!(:user) { FactoryGirl.create(:user) }
  let!(:comment) { create(:comment, user: user) }
  subject { cell('commenters').(:show, limit: 10) }

  it { is_expected.to include user.name }
end
