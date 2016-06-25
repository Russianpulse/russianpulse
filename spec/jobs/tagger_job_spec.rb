require 'rails_helper'

RSpec.describe TaggerJob, :type => :job do
  let(:post) { FactoryGirl.create :post }
  let(:job) { TaggerJob.new }
  let!(:tag) { FactoryGirl.create :tag }

  it "should add tag if title match" do
    post.title = "All about our president Putin"
    tag.update_attribute :title, "President"
    job.perform(post)
    expect(post.tags).to include(tag)
  end

  it "should add russian tag if title match" do
    post.title = "All about our Президента Putin"
    tag.update_attribute :title, "президент"
    job.perform(post)
    expect(post.tags).to include(tag)
  end

  it "should add russian tag if alias match" do
    post.title = "All about our Putin"
    tag.update_attributes :title => "Putin", :aliases => "Mr. President"
    job.perform(post)
    expect(post.tags).to include(tag)
  end

  it "should add post to tag" do
    post.title = "All about our president Putin"
    tag.update_attribute :title, "President"
    job.perform(post)
    expect(tag.reload.posts).to include(post)
  end

  it "should add tag if text match" do
    post.body = "All about our president Putin"
    tag.update_attribute :title, "President"
    job.perform(post)
    expect(post.tags).to include(tag)
  end

  it "should remove old tags from post" do
    post.body = "All about our president Putin"
    job.perform(post)

    post.body = "All about our _____ Putin"
    job.perform(post)

    expect(post.tags).not_to include(tag)
  end

  it "should remove old posts from tags" do
    post.body = "All about our president Putin"
    job.perform(post)

    post.body = "All about our _____ Putin"
    job.perform(post)

    expect(tag.reload.posts).not_to include(post)
  end

  it "should add tag if tag alias match" do
    post.title = "All about our Putin"
    tag.update_attribute :aliases, "Putin"
    job.perform(post)
    expect(post.tags).to include(tag)
  end

  it "should add tag if multiword tag" do
    post.title = "All about our Russia Federation"
    tag.update_attribute :title, "Russia Federation"
    job.perform(post)
    expect(post.tags).to include(tag)
  end
end
