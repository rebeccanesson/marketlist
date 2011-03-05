require 'spec_helper'

describe Product do
  before(:each) do
    @product_family = Factory(:product_family)
    @attr = { :name => "Slicing Tomatoes", 
              :description => "1 case of slicing tomatoes", 
              :base_price => 20.00, 
              :organic => false, 
              :product_family => @product_family }
  end
  
  it "should create a new instance given valid attributes" do
    Product.create!(@attr)
  end
  
  it "should require a name" do
    no_name_prod = Product.new(@attr.merge(:name => ""))
    no_name_prod.should_not be_valid
  end
  
  it "should require a description" do
    no_desc_user = Product.new(@attr.merge(:description => ""))
    no_desc_user.should_not be_valid
  end
  
  it "should require a product family" do 
    no_product_family = Product.new(@attr.merge(:product_family => nil))
    no_product_family.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_prod = Product.new(@attr.merge(:name => long_name))
    long_name_prod.should_not be_valid
  end 
  
  it "should reject nil base_price" do 
    prod = Product.new(@attr.merge(:base_price => nil))
    prod.should_not be_valid
  end
  
  it "should reject negative base_price" do 
    prod = Product.new(@attr.merge(:base_price => -1))
    prod.should_not be_valid
  end
  
end
