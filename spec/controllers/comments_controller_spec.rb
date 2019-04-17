require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe CommentsController, type: :controller do
  include ApplicationHelper
  include PostsHelper

  let(:user_attributes) { FactoryGirl.attributes_for(:user) }

  # This should return the minimal set of attributes required to create a valid
  # Comment. As you add validations to Comment, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      comment: FactoryGirl.attributes_for(:comment), post_id: current_post.id
    }
  end

  let(:invalid_attributes) do
    { comment: { comment: '' }, post_id: current_post.id }
  end

  let(:valid_session) do
    {}
  end

  let(:current_post) { FactoryGirl.create(:post) }
  let(:current_user) { create :user }

  describe 'POST #create' do
    before do
      allow(controller).to receive(:verify_recaptcha) { true }
      sign_in current_user
    end

    context 'with valid params' do
      subject(:request) do
        post :create, params: valid_attributes, session: valid_session
      end

      it 'creates a new Comment' do
        expect { request }.to change(current_post.comments, :count).by(1)
      end

      it 'assigns a newly created comment as @comment' do
        request
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end

      it 'redirects to the created comment' do
        request
        expect(response).to redirect_to(smart_post_path(current_post, anchor: "comment_#{assigns(:comment).id}"))
      end

      context 'when *subscribe* box is checked' do
        before do
          valid_attributes.merge!(subscribe: 1)
        end

        it 'should subscribe user on a conversation' do
          request
          expect(current_post.followers).to include current_user
        end
      end

      context 'when comment is duplicated (looks like a SPAM)' do
        let(:user_attributes) { user.attributes.symbolize_keys }
        before { create :comment, comment: valid_attributes[:comment][:comment], user: current_user }
        it 'should mark user as flagged' do
          post :create, params: valid_attributes, session: valid_session
          expect(current_user.reload.flagged).to eq true
        end
      end
    end

    context 'with invalid params' do
      subject(:request) do
        post :create, params: invalid_attributes, session: valid_session
      end

      it 'should not create a new Comment' do
        expect { request }.not_to change(current_post.comments, :count)
      end

      it "re-renders the 'new' template" do
        request
        expect(response).to redirect_to(smart_post_path(current_post))
      end
    end
  end
end
