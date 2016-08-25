require 'rails_helper'

RSpec.describe "Blogs", type: :request do
  let!(:post) { FactoryGirl.create :post }

  describe "GET /archive" do
    it "works!" do
      get '/archive'
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /archive/2014/7/11" do
    it "works!" do
      get '/archive/2014/7/11'
      expect(response).to have_http_status(200)
    end
  end
end
