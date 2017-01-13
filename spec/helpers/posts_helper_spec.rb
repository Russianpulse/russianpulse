require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the PostsHelper. For example:
#
# describe PostsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe PostsHelper, type: :helper do
  describe '.post_teaser_for' do
    subject { helper.post_teaser_for(post) }
    let(:post) { FactoryGirl.create :post }
    let!(:post_teaser) { FactoryGirl.create :post_teaser }

    it { is_expected.to eq post_teaser.body }

    describe 'for another post' do
      subject { helper.post_teaser_for(another_post) }
      let(:another_post) { FactoryGirl.create :post }
      let!(:another_post_teaser) { FactoryGirl.create :post_teaser }

      it { is_expected.not_to eq post_teaser_for(post) }
    end

    context 'when no teasers' do
      before { PostTeaser.delete_all }
      it { is_expected.to be_blank }
    end
  end
end
