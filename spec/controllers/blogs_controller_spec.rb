require 'rails_helper'

RSpec.describe BlogsController, type: :controller do
  describe 'GET show' do
    let(:blog) { FactoryGirl.create :blog }
    before { get :show, params: { slug: blog.slug } }
    subject { response }
    it { should be_success }
  end
end
