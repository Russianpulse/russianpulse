require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  describe 'PUT block' do
    let(:admin) { create :user, role: :admin }
    let!(:post) { create :post }

    before { sign_in current_user }

    context 'admin' do
      let(:current_user) { admin }

      it 'should block post' do
        put :block, params: { id: post.id }
        expect(response).to have_http_status(:redirect)
        expect(post.reload).to be_blocked 
      end
    end

    context 'admin' do
      let(:current_user) { create :user }

      it 'should block post' do
        expect do
          put :block, params: { id: post.id }
        end.to raise_error Pundit::NotAuthorizedError

        expect(post.reload).not_to be_blocked 
      end
    end
  end
end
