require 'rails_helper'

RSpec.describe RedirectsController, type: :controller do
  describe "GET #bye" do
    it "returns http success" do
      VCR.use_cassette("remote_article") do
        get :bye, url: "http://russianpulse.ru/colonelcassad/2016/02/21/1500394-krym-problemy-bezopasnosti"
        expect(response).to have_http_status(:success)
      end
    end
  end
end
