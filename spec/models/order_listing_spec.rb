require 'spec_helper'

describe OrderListing do
  before(:each) do
    @user = Factory(:user)
    @product_family = Factory(:product_family, :name => "Eggplant")
    @order_list = Factory(:order_list, :user => @user)
    @attr = { :product_family => @product_family, 
              :order_list => @order_list,  
              :quantity => 2 }
  end
  
  it "should create a new instance given valid attributes" do
    OrderListing.create!(@attr)
  end
  
  it "should require a product family" do
    no_prod = OrderListing.new(@attr.merge(:product_family => nil))
    no_prod.should_not be_valid
  end
  
  it "should require an order list" do 
    no_ol = OrderListing.new(@attr.merge(:order_list => nil))
    no_ol.should_not be_valid
  end
  
  it "should require a quantity" do
    no_quant = OrderListing.new(@attr.merge(:quantity => nil))
    no_quant.should_not be_valid
  end
  
  it "should require a positive quantity" do 
    zero_quant = OrderListing.new(@attr.merge(:quantity => 0))
    zero_quant.should_not be_valid
  end 

end
