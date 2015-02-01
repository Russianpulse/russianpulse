require 'rails_helper'

RSpec.describe TagsController, :type => :controller do

  describe "GET show" do
    it "returns http success" do
      tag = FactoryGirl.create :tag
      get :show, :tag => tag.slug
      expect(response).to have_http_status(:success)
    end
  end

end
