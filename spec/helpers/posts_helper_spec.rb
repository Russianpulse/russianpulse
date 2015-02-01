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
RSpec.describe PostsHelper, :type => :helper do
  describe "#format_post" do
    it "should not raise when nil passwed" do
      expect do
        helper.format_post(nil)
      end.not_to raise_error
    end
    it "should not remove paragraphs with text" do
      expect(helper.format_post("<p>Text</p>")).to match("Text")
    end

    it "should remove paragraphs without text and with spaces" do
      expect(helper.format_post("<p>  </p>")).not_to match("<p")
    end

    it "should remove paragraphs without text and with &nbsp;" do
      expect(helper.format_post("<p>&nbsp;</p>")).not_to match("<p")
    end

    it "should not remove paragraphs with img" do
      expect(helper.format_post("<p><img src='' /></p>")).to match("img")
    end

    it "should not remove paragraphs with video" do
      expect(helper.format_post("<p><video src='' /></p>")).to match("video")
    end

    it "should not remove paragraphs with iframe" do
      expect(helper.format_post("<p><iframe src='' /></p>")).to match("iframe")
    end

    it "should mark tiny paragraphs" do
      expect(helper.format_post("<p>Small text</p>")).to match(/class=\"tiny\"/)
    end

    it "should replace divs with paragraphs" do
      expect(helper.format_post("<div>Text</div>")).not_to match("<div>")
    end

    it "should remove brs" do
      expect(helper.format_post("Text<br /><br>Next line")).not_to match("br")
    end

    describe "headers" do
      it "should replace h1 with h2" do
        html = helper.format_post("<h1>Header</h1>")

        expect(html).not_to match("h1")
        expect(html).to match("<h2>Header</h2>")
      end

      it "should replace h3 with h2 if h3 is highest level" do
        expect(helper.format_post("<h3>Header</h3>")).to match("<h2>Header</h2>")
      end

      it "should replace h4 with h2 if h4 is highest level" do
        expect(helper.format_post("<h4>Header</h4>")).to match("<h2>Header</h2>")
      end

      it "should replace h4 with h3 if h3 is highest level" do
        expect(helper.format_post("<h3>Header Big</h3><h4>Header Small</h4>")).to match("<h3>Header Small</h3>")
      end
    end
  end

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
