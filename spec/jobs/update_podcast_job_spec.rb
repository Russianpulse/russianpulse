require 'rails_helper'
require 'open-uri'

RSpec.describe UpdatePodcastJob, type: :job do
  let(:job) { UpdatePodcastJob.new }
  let(:blog) { Podcast.new title: 'Blog', slug: 'blog' }

  describe '#perform' do
    before do
      blog.save!
      allow(job).to receive(:need_check?).and_return(true)
      blog.feed_url = 'http://youtube-podcasts.russianpulse.ru/nstarikovru/user.xml'

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
          blog.posts.last
        end

        let(:default_stream) { :inbox }
        let(:blog) { create :blog, default_stream: default_stream }

        its(:enclosures) { is_expected.to be_present }
      end
    end
  end
end
