require 'rails_helper'

RSpec.describe RedirectsController, type: :controller do
  describe 'GET #bye' do
    it 'returns http success' do
      get :bye, params: { url: 'https://goo.gl/ubUBub' }
      expect(response).to have_http_status(:success)
    end

    it 'returns http redirect' do
      get :bye, params: { url: 'http://russianpulse.ru/colonelcassad/2016/02/21/1500394-krym-problemy-bezopasnosti' }
      expect(response).to have_http_status(:not_found)
    end
  end
end
