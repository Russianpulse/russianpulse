require 'rails_helper'

RSpec.describe SetUserCountryJob, type: :job do
  it 'should set user country code by IP' do
    user = create :user, current_sign_in_ip: '94.228.243.75'

    VCR.use_cassette :geocoder do
      SetUserCountryJob.new.perform(user)
    end

    expect(user.reload.country_code).to eq 'ru'
  end

  it 'should set Russia when Crime' do
    user = create :user, current_sign_in_ip: '188.191.19.242'

    VCR.use_cassette :geocoder_crime do
      SetUserCountryJob.new.perform(user)
    end

    expect(user.reload.country_code).to eq 'ru'
  end
end
