require 'rails_helper'

describe YandexTurboCell, type: :cell do
  include Cell::Testing
  controller PostsController

  let(:post) { create :post, :commented }
  let(:posts) { [post] }

  subject { cell('yandex_turbo', posts).call(:show) }

  it { is_expected.to include post.title }
end
