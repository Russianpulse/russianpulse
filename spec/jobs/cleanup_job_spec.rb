require 'rails_helper'

RSpec.describe CleanupJob, type: :job do
  let(:job) { described_class.new }
  let!(:post) { create :post }
  it 'should work' do
    job.perform
  end
end
