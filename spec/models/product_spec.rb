require 'spec_helper'

describe Product do
  before(:each) do
    @attr = { :name => "Slicing Tomatoes", 
              :description => "1 case of slicing tomatoes", 
              :base_organic_price => 2000, 
              :base_conventional_price => 1500, 
              :organic_status => "organic and conventional" }
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
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_prod = Product.new(@attr.merge(:name => long_name))
    long_name_prod.should_not be_valid
  end
  
  it "should reject organic_status not in ORGANIC_STATUSES" do 
    bad_status_prod = Product.new(@attr.merge(:organic_status => "foobar"))
    bad_status_prod.should_not be_valid
  end 
  
  it "should reject nil base_organic_price if an organic status is chosen" do 
    prod = Product.new(@attr.merge(:base_organic_price => nil))
    prod.should_not be_valid
  end
  
  it "should reject nil base_conventional_price if a conventional status is chosen" do 
    prod = Product.new(@attr.merge(:base_conventional_price => nil))
    prod.should_not be_valid
  end
  
  it "should reject negative base_organic_price" do 
    prod = Product.new(@attr.merge(:base_organic_price => -1))
    prod.should_not be_valid
  end
  
  it "should reject negative base_conventional_price" do 
    prod = Product.new(@attr.merge(:base_conventional_price => -1))
    prod.should_not be_valid
  end
  
end
