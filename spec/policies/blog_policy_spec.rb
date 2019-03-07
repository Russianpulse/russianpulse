require 'rails_helper'

RSpec.describe BlogPolicy do
  subject { described_class }

  # permissions :update?, :edit? do
  #   it "denies access if post is published" do
  #     expect(subject).not_to permit(User.new(admin: false), Post.new(published: true))
  #   end
  # end

  describe 'scope' do
    subject { described_class::Scope.new(user, Blog.all).resolve }
    let(:user) { create :user }
    let(:blog) { create :blog }

    context 'when guest' do
      let(:user) { create :user }
      it { is_expected.not_to include blog }
    end

    context 'when admin' do
      let(:user) { create :user, :admin }
      it { is_expected.to include blog }
    end

    context 'when editor' do
      let(:user) { create :user }
      let(:blog_of_user) do
        b = create :blog
        BlogUser.create user: user, blog: b, role: 'editor'

        b
      end
      let(:blog_of_another_user) do
        b = create :blog
        BlogUser.create user: create(:user), blog: b, role: 'editor'

        b
      end

      it { is_expected.to include blog_of_user }
      it { is_expected.not_to include blog_of_another_user }
    end
  end
end
