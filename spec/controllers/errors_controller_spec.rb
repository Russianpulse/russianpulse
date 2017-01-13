require 'rails_helper'

RSpec.describe ErrorsController, type: :controller do
  describe 'GET not_found' do
    it 'returns http success' do
      get :not_found
      expect(response).to have_http_status(404)
    end
  end

  describe 'GET exception' do
    it 'returns http success' do
      get :exception
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET routing' do
    it 'returns http success' do
      get :routing
      expect(response).to have_http_status(:success)
    end
  end
end
