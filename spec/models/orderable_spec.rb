require 'spec_helper'

describe Orderable do
  before(:each) do
    @user = Factory(:user)
    @organic_user = Factory(:user, :email => "farmer@organic.org", :organic => true)
    @product = Factory(:product)
    @order_list = Factory(:order_list, :user => @user)
    @order_listing = Factory(:order_listing, :order_list => @order_list)
    @attr = { :product => @product, 
              :order_listing => @order_listing,  
              :organic_price => 10.00, 
              :conventional_price => 8.00 }
    @orderable = Factory(:orderable,           
                        :product => @product, 
                        :order_listing => @order_listing,  
                        :organic_price => 10.00, 
                        :conventional_price => 8.00)
  end
  
  it "should create a new instance given valid attributes" do
    Orderable.create!(@attr)
  end
  
  it "should require a product" do
    no_prod = Orderable.new(@attr.merge(:product => nil))
    no_prod.should_not be_valid
  end
  
  # THIS IS COMMENTED OUT NOT BECAUSE IT IS WRONG BUT BECAUSE CREATING ORDERABLES THROUGH A NESTED ORDER LISTING
  # FORM BREAKS WHEN THIS VALIDATION IS PRESENT
  # it "should require an order listing" do 
  #   no_ol = Orderable.new(@attr.merge(:order_listing => nil))
  #   no_ol.should_not be_valid
  # end
  
  it "should require either an organic price or a conventional price" do
    no_price = Orderable.new(@attr.merge(:organic_price => nil, :conventional_price => nil))
    no_price.should_not be_valid
  end
  
  it "should allow only an organic price" do 
    no_con_price = Orderable.new(@attr.merge(:conventional_price => nil))
    no_con_price.should be_valid
  end
  
  it "should allow only a conventional price" do 
    no_con_price = Orderable.new(@attr.merge(:organic_price => nil))
    no_con_price.should be_valid
  end
  
  it "should not allow negative organic price" do 
    neg_price = Orderable.new(@attr.merge(:organic_price => -1.00))
    neg_price.should_not be_valid
  end
  
  it "should not allow negative conventional price" do 
    neg_price = Orderable.new(@attr.merge(:conventional_price => -1.00))
    neg_price.should_not be_valid
  end
  
  it "should give the organic price for a user marked as organic" do 
    @orderable.price_for_user(@organic_user).should == @orderable.organic_price
  end
  
  it "should give the conventional price for a user not marked as organic" do 
    @orderable.price_for_user(@user).should == @orderable.conventional_price
  end
  
  

end
