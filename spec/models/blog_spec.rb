require 'rails_helper'

RSpec.describe Blog, :type => :model do
  let(:blog) { FactoryGirl.create :blog }

  describe '#cleanup_html' do
    subject { blog.cleanup_html(source_html) }

    let(:blog) { Blog.new }

    let(:source_html) {
      <<-HTML
      <title>Title</title>
      <body>
        <p class="post-body">
          Hi there! What do You think about this picture?
          <img src="#" />

          Bye there!

          <span class="social-buttons"><span>VK</span></span>
        </p>

        <div>footer text</div>
      </body>

      HTML
    }

    it "should remove by regexp rule" do
      blog.text_cleanup_rules = "remove regexp /what do\s?you/i"
      is_expected.not_to include("What do You")
    end

    it "should remove by css rule" do
      blog.text_cleanup_rules = "remove css .social-buttons"
      is_expected.not_to include("VK")
    end

    it "should select by css rule" do
      blog.text_cleanup_rules = "select css .post-body"
      is_expected.not_to include("footer")
    end

    it "should not raise when no rules" do
      blog.text_cleanup_rules = nil
      expect{ subject }.not_to raise_error
    end

    context 'when fetching from ftr.fivefilters.org' do
      before do
        blog.feed_url = 'http://ftr.fivefilters.org/makefulltextfeed.php?url=http%3A%2F%2Fwww.novorosinform.org%2Frss%2Frss.xml&max=3'
      end

      let(:source_html) {
        <<-HTML
        <title>Title</title>
        <body>
          <p>
          Some text
          </p>
          <p><strong><a href="https://blockads.fivefilters.org">Let's block ads!</a></strong> <a href="https://github.com/fivefilters/block-ads/wiki/There-are-no-acceptable-ads">(Why?)</a></p>
        </body>

        HTML
      }

      it { expect { subject }.not_to raise_error }
      it { is_expected.not_to include('Let\'s block') }
      it { is_expected.not_to include('Why?') }
      it { is_expected.to include('Some text') }
    end
  end

  describe 'health_status' do
    subject { blog.health_status }

    it { is_expected.to eq 0 }

    context 'when 3 times failed and 7 times succeded' do
      before do
        3.times { blog.failed_to_check! }
        7.times { blog.checked! }
      end

      it { is_expected.to eq 3 }
    end
  end

  describe 'recent_fetches' do
    subject { blog.recent_fetches }
    before { 10.times { blog.checked! } }

    its(:size) { is_expected.to eq 10 }
  end
end
