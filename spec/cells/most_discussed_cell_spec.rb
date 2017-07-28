require 'rails_helper'

describe MostDiscussed, type: :cell do
  include Cell::Testing
  controller WelcomeController

  let!(:current_post) { create :post, :commented }
  let!(:post) { create :post, :commented }
  let!(:post_without_comments) { create :post }
  before do
    5.times do
      create :post, :commented
    end
  end

  subject { cell('most_discussed', current_post).call(:show) }

  it { is_expected.to include post.title }
  it { is_expected.not_to include post_without_comments.title }
  it { is_expected.not_to include current_post.title }
end
