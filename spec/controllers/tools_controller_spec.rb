require 'rails_helper'

RSpec.describe ToolsController, :type => :controller do

  describe "GET cleanup" do
    it "returns http success" do
      get :cleanup
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
