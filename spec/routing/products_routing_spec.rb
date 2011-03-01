require "spec_helper"

describe ProductsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/products" }.should route_to(:controller => "products", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/products/new" }.should route_to(:controller => "products", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/products/1" }.should route_to(:controller => "products", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/products/1/edit" }.should route_to(:controller => "products", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/products" }.should route_to(:controller => "products", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/products/1" }.should route_to(:controller => "products", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/products/1" }.should route_to(:controller => "products", :action => "destroy", :id => "1")
    end

  end
end
