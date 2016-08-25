require 'rails_helper'

RSpec.describe PingerJob, type: :job do
  let!(:post) { FactoryGirl.create :post }

  it 'should work' do
    VCR.use_cassette 'pinger_job' do
      expect do
        PingerJob.perform_now(post)
      end.not_to raise_error
    end
  end
end
