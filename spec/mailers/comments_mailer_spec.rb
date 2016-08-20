require "rails_helper"

RSpec.describe CommentsMailer, type: :mailer do
  describe "created" do
    let(:comment) { create :comment }
    let(:user) {  build :user }
    let(:mail) { CommentsMailer.created(comment, user) }

    describe 'mail' do
      subject { mail }

      its(:subject) { is_expected.to eq "#{comment.user.name} ответил на Ваш комментарий" }
      its(:to) { is_expected.to include user.email }
    end
  end
end
