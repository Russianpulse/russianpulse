require 'rails_helper'

RSpec.describe BlogsController, type: :controller do
  describe 'GET show' do
    let(:blog) { FactoryGirl.create :blog }
    subject { response }

    context 'HTML' do
      before { get :show, params: { slug: blog.slug } }
      it { should be_success }
    end

    context 'when unknown format' do
      render_views
      before { get :show, params: { slug: blog.slug }, format: :txt }
      its(:code) { should eq '400' }
      its(:body) { should include 'Неверный формат' }
    end

    context 'when not found and unknown format' do
      render_views
      before { get :show, params: { slug: 'foobar' }, format: :txt }
      its(:code) { should eq '404' }
      its(:body) { should include 'Страница не найдена' }
    end
  end
end
