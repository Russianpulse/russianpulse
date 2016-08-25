require 'rails_helper'

RSpec.describe RefreshSitemapJob, type: :job do
  let!(:post) { FactoryGirl.create :post }

  it 'should work' do
    expect do
      RefreshSitemapJob.perform_now
    end.not_to raise_error
  end
end
