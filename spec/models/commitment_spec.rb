require 'spec_helper'

describe Commitment do
  before(:each) do
    @user = Factory(:user)
    @seller = Factory(:user, :email => Faker::Internet.email)
    @product_family = Factory(:product_family, :name => "Tomatoes")
    @product = Factory(:product, :product_family => @product_family)
    @order_list = Factory(:order_list, :user => @user)
    @order_listing = Factory(:order_listing, :order_list => @order_list, :product_family => @product_family, :quantity => 2)
    @orderable = Factory(:orderable, :order_listing => @order_listing, :product => @product)
    @orderable2 = Factory(:orderable, :order_listing => @order_listing, :product => @product)
    @attr = { :quantity => 2,   
                    :user => @seller, 
                    :orderable => @orderable
                  }
  end
  
  it "should create a new instance given valid attributes" do
    Commitment.create!(@attr)
  end
  
  it "should require a quantity" do
    no_quant = Commitment.new(@attr.merge(:quantity => nil))
    no_quant.should_not be_valid
  end
  
  it "should require an orderable" do 
    no_ol = Commitment.new(@attr.merge(:orderable => nil))
    no_ol.should_not be_valid
  end

  it "should allow two commitments for the same orderable" do 
    comm1 = Commitment.create!(@attr.merge(:quantity => 1))
    comm2 = Commitment.create!(@attr.merge(:quantity => 1))
  end 
    
  it "should require a user" do
    no_user = Commitment.new(@attr.merge(:user => nil))
    no_user.should_not be_valid
  end
  
  it "should not allow a negative quantity" do 
    neg_quant = Commitment.new(@attr.merge(:quantity => -1))
    neg_quant.should_not be_valid
  end

end
