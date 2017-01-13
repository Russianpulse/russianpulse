require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  before do
    sign_in FactoryGirl.create(:user, role: :admin)
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update_post' do
    it 'updates posts stream' do
      post_record = FactoryGirl.create :post, stream: :inbox

      post :update_post, params: { id: post_record.id, post: { stream: :pulse }, format: :json }
      expect(response).to have_http_status(:success)
      expect(post_record.reload.stream).to eq 'pulse'
    end
  end
end
