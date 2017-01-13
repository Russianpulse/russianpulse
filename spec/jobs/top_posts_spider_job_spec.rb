require 'rails_helper'

RSpec.describe TopPostsSpiderJob, type: :job do
  let!(:post) { create :post }

  it 'should work' do
    worker = TopPostsSpiderJob.new
    worker.perform_now
  end
end
