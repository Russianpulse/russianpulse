require 'rails_helper'

RSpec.describe UpdateBlogJob, :type => :job do
  describe "#need_check?" do
    let(:blog) { Blog.new }
    let(:job) { UpdateBlogJob.new }

    it "should be true if never checked" do
      blog.checked_at = nil
      expect(job.need_check?(blog)).to eq(true)
    end

    it "should be true if checked more than 60 minutes ago" do
      blog.checked_at = 61.minutes.ago
      expect(job.need_check?(blog)).to eq(true)
    end

    it "should be true if checked more than average needed minutes ago" do
      blog.posts_per_hour = 2
      blog.checked_at = 31.minutes.ago
      expect(job.need_check?(blog)).to eq(true)
    end

    it "should be false if checked less than average needed minutes ago" do
      blog.posts_per_hour = 2
      blog.checked_at = 29.minutes.ago
      expect(job.need_check?(blog)).to eq(false)
    end
  end
end
