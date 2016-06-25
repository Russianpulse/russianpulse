require 'rails_helper'

RSpec.describe WelcomeController, :type => :controller do

  describe "GET index" do
    before { FactoryGirl.create(:post) }
    before { FactoryGirl.create(:post, :top) }
    
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
