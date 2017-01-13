require 'rails_helper'
require 'open-uri'

RSpec.describe UpdateBlogJob, type: :job do
  let(:job) { UpdateBlogJob.new }
  let(:blog) { Blog.new title: 'Blog', slug: 'blog' }

  describe '#perform' do
    before do
      blog.save!
      allow(job).to receive(:need_check?).and_return(true)
      blog.feed_url = 'http://www.example.com/rss.xml'

      allow(job).to receive(:url_after_redirects) { |url| url }

      stub_request(:get, /www.google-analytics.com.*/)
        .to_return(status: 200, body: '', headers: {})
    end

    it 'should raise error when fetch failed' do
      expect do
        stub_request(:get, 'http://www.example.com/rss.xml')
          .to_return(status: 200, body: 'bad body', headers: {})

        job.perform(blog)
      end.to raise_error(Feedjira::NoParserAvailable)
    end

    context 'when feed has new item' do
      before do
        feed_body = File.read(File.join(Rails.root, 'spec/jobs/fixtures/feed.xml'))
        stub_request(:get, 'http://www.example.com/rss.xml')
          .to_return(status: 200, body: feed_body, headers: {})
      end

      it 'should add new posts' do
        expect do
          job.perform(blog)
        end.to change(blog.posts, :count).by(3)
      end

      it 'should update blog fetch status' do
        expect do
          job.perform(blog)
        end.to change { blog.recent_fetches.size }.by(1)
      end

      describe 'new post' do
        subject do
          job.perform(blog)
          blog.posts.last
        end

        let(:default_stream) { :inbox }
        let(:blog) { create :blog, default_stream: default_stream }

        its(:stream) { is_expected.to eq 'inbox' }

        context 'when blogs default_stream is "news"' do
          let(:default_stream) { :news }
          its(:stream) { is_expected.to eq 'news' }
        end
      end
    end
  end

  describe '#need_check?' do
    it 'should be true if never checked' do
      blog.checked_at = nil
      expect(job.need_check?(blog)).to eq(true)
    end

    it 'should be true if checked more than 60 minutes ago' do
      blog.checked_at = 61.minutes.ago
      expect(job.need_check?(blog)).to eq(true)
    end

    it 'should be true if checked more than average needed minutes ago' do
      blog.posts_per_hour = 2
      blog.checked_at = 31.minutes.ago
      expect(job.need_check?(blog)).to eq(true)
    end

    it 'should be false if checked less than average needed minutes ago' do
      blog.posts_per_hour = 2
      blog.checked_at = 29.minutes.ago
      expect(job.need_check?(blog)).to eq(false)
    end

    it 'should not raise when posts_per_hour=0' do
      blog.posts_per_hour = 0
      blog.checked_at = 29.minutes.ago
      expect do
        job.need_check?(blog)
      end.not_to raise_error
    end
  end
end
