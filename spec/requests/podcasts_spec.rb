require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /' do
    context 'when no episodes' do
      before { get '/podcasts' }
      it { expect(response).to have_http_status(200) }
    end

    context 'when posts exist' do
      before do
        FactoryGirl.create(:episode)
        get '/podcasts'
      end

      it { expect(response).to have_http_status(200) }
    end
  end
end
