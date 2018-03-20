require "rails_helper"

RSpec.describe Blogs::PostsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/blogs/posts").to route_to("blogs/posts#index")
    end

    it "routes to #new" do
      expect(:get => "/blogs/posts/new").to route_to("blogs/posts#new")
    end

    it "routes to #show" do
      expect(:get => "/blogs/posts/1").to route_to("blogs/posts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/blogs/posts/1/edit").to route_to("blogs/posts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/blogs/posts").to route_to("blogs/posts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/blogs/posts/1").to route_to("blogs/posts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/blogs/posts/1").to route_to("blogs/posts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/blogs/posts/1").to route_to("blogs/posts#destroy", :id => "1")
    end

  end
end
