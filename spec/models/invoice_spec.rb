require 'spec_helper'

describe Invoice do
  before(:each) do
    @user = Factory(:user)
    @order_list = Factory(:order_list, :user => @user)
    @attr = { :user => @user, 
              :order_list => @order_list
            }
  end
  
  it "should create a new instance given valid attributes" do
    Invoice.create!(@attr)
  end
  
  it "should require a user" do
    no_user = Invoice.new(@attr.merge(:user => nil))
    no_user.should_not be_valid
  end
  
  it "should require an order list" do 
    no_ol = Invoice.new(@attr.merge(:order_list => nil))
    no_ol.should_not be_valid
  end

end
