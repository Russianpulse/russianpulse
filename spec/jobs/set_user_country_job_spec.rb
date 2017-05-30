require 'rails_helper'

RSpec.describe SetUserCountryJob, type: :job do
  it 'should set user country code by IP' do
    user = create :user, current_sign_in_ip: '94.228.243.75'

    VCR.use_cassette :geocoder do
      SetUserCountryJob.new.perform(user)
    end

    expect(user.reload.country_code).to eq 'ru'
  end
end
