require 'rails_helper'

RSpec.describe ArchiveController, type: :controller do
  let!(:post) { FactoryGirl.create :post }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #day" do
    let(:year) { post.created_at.year }
    let(:month) { post.created_at.month }
    let(:day) { post.created_at.day }

    it "returns http success" do
      get :day, params: { year: year, month: month, day: day }
      expect(response).to have_http_status(:success)
    end
  end
end
