require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe MarketsController do

  def mock_market(stubs={})
    @mock_market ||= mock_model(Market, stubs).as_null_object
  end
  
  before(:each) do 
    User.all.each { |u| u.destroy }
  end

  describe "GET index" do
    it "assigns all markets as @markets" do
      Market.stub(:all) { [mock_market] }
      get :index
      assigns(:markets).should eq([mock_market])
    end
  end

  describe "GET show" do
    it "assigns the requested market as @market" do
      Market.stub(:find).with("37") { mock_market }
      get :show, :id => "37"
      assigns(:market).should be(mock_market)
    end
  end

  describe "GET new" do
    it "assigns a new market as @market" do
      Market.stub(:new) { mock_market }
      get :new
      assigns(:market).should be(mock_market)
    end
  end

  describe "GET edit" do
    it "assigns the requested market as @market" do
      Market.stub(:find).with("37") { mock_market }
      get :edit, :id => "37"
      assigns(:market).should be(mock_market)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created market as @market" do
        Market.stub(:new).with({'these' => 'params'}) { mock_market(:save => true) }
        post :create, :market => {'these' => 'params'}
        assigns(:market).should be(mock_market)
      end

      it "redirects to the created market" do
        Market.stub(:new) { mock_market(:save => true) }
        post :create, :market => {}
        response.should redirect_to(admin_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved market as @market" do
        Market.stub(:new).with({'these' => 'params'}) { mock_market(:save => false) }
        post :create, :market => {'these' => 'params'}
        assigns(:market).should be(mock_market)
      end

      it "re-renders the 'new' template" do
        Market.stub(:new) { mock_market(:save => false) }
        post :create, :market => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested market" do
        Market.stub(:find).with("37") { mock_market }
        mock_market.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :market => {'these' => 'params'}
      end

      it "assigns the requested market as @market" do
        Market.stub(:find) { mock_market(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:market).should be(mock_market)
      end

      it "redirects to the market" do
        Market.stub(:find) { mock_market(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_url)
      end
    end

    describe "with invalid params" do
      it "assigns the market as @market" do
        Market.stub(:find) { mock_market(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:market).should be(mock_market)
      end

      it "re-renders the 'edit' template" do
        Market.stub(:find) { mock_market(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested market" do
      Market.stub(:find).with("37") { mock_market }
      mock_market.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the markets list" do
      Market.stub(:find) { mock_market }
      delete :destroy, :id => "1"
      response.should redirect_to(markets_url)
    end
  end

end
