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
  let(:valid_attributes) {
    {
      comment: FactoryGirl.attributes_for(:comment).merge(user_attributes: {
        name: user_attributes[:name],
        email: user_attributes[:email],
      }), post_id: current_post.id
    }
  }

  let(:invalid_attributes) {
    { comment: { comment: "Me comment", user_attributes: { name: "Name", email: "bademail" } }, post_id: current_post.id }
  }

  let(:valid_session) {
    {}
  }

  let(:current_post) { FactoryGirl.create(:post) }

  describe "POST #create" do
    before do
      expect(controller).to receive(:verify_recaptcha) { true }
    end

    context "with valid params" do
      subject(:request) do
        post :create, valid_attributes, valid_session
      end

      it "creates a new Comment" do
        expect { request }.to change(current_post.comments, :count).by(1)
      end

      it "assigns a newly created comment as @comment" do
        request
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end

      it "redirects to the created comment" do
        request
        expect(response).to redirect_to(smart_post_path(current_post, anchor: "comment_#{assigns(:comment).id}"))
      end

      it "should register a new user" do
        expect { request }.to change(User, :count).by(1)
      end

      context "when user already registered" do
        let!(:user) { FactoryGirl.create :user, user_attributes }
        it { expect{ request }.not_to change(User, :count) }
        it { expect{ request }.to change(user.comments, :count).by(1) }
      end

      describe "user" do
        before do
          post :create, valid_attributes, valid_session
        end
        subject { assigns(:user) }

        it { should be_a(User) }
        its(:email) { should eq(user_attributes[:email]) }
      end
    end

    context "with invalid params" do
      subject(:request) do
        post :create, invalid_attributes, valid_session
      end

      it "should not create a new Comment" do
        expect { request }.not_to change(current_post.comments, :count)
      end

      it "re-renders the 'new' template" do
        request
        expect(response).to redirect_to(smart_post_path(current_post))
      end
    end
  end
end
