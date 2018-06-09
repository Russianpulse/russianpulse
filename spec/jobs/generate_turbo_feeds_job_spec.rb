require 'rails_helper'

RSpec.describe GenerateTurboFeedsJob, type: :job do
  let!(:post) { create :post }

  it 'should work' do
    described_class.new.perform
  end
end
