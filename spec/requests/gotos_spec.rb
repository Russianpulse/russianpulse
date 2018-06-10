require 'rails_helper'

RSpec.describe "Gotos", type: :request do
  describe "GET /goto" do
    it "works! (now write some real specs)" do
      get "/goto?foo=bar"
      expect(response).to have_http_status(:redirect)
    end
  end
end
