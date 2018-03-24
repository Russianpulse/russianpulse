require 'rails_helper'
require 'open-uri'

RSpec.describe UpdatePodcastJob, type: :job do
  let(:job) { UpdatePodcastJob.new }
  let(:blog) { create :podcast }

  describe '#perform' do
    before do
      blog.save!
      allow(job).to receive(:need_check?).and_return(true)
      blog.feed_url = 'https://yt.mazavr.com/channels/UCVPYbobPRzz0SjinWekjUBw.atom'

      allow(job).to receive(:url_after_redirects) { |url| url }

      stub_request(:get, /www.google-analytics.com.*/)
        .to_return(status: 200, body: '', headers: {})
    end

    context 'when feed has new item' do
      describe 'new post' do
        subject do
          VCR.use_cassette :podcast_feed do
            job.perform(blog)
          end
          blog.episodes.reload.last
        end

        let(:default_stream) { :inbox }

        it { is_expected.to be_an Episode }
        its(:enclosures) { is_expected.to be_present }
      end
    end
  end
end
