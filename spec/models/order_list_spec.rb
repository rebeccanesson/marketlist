require 'spec_helper'

describe OrderList do
  before(:each) do
    @attr = { :order_start => Time.now + 3.days, 
              :order_end   => Time.now + 5.days, 
              :delivery_start => Time.now + 8.days, 
              :delivery_end   => Time.now + 8.days + 5.hours, 
              :user => Factory(:user)
            }
  end
  
  it "should create a new instance given valid attributes" do
    OrderList.create!(@attr)
  end
  
  it "should require a start date" do
    no_start_ol = OrderList.new(@attr.merge(:order_start => nil))
    no_start_ol.should_not be_valid
  end
  
  it "should require an end date" do
    no_end_ol = OrderList.new(@attr.merge(:order_end => nil))
    no_end_ol.should_not be_valid
  end
  
  it "should require a delivery date" do
    no_due_ol = OrderList.new(@attr.merge(:delivery_start => nil))
    no_due_ol.should_not be_valid
  end
  
  it "should require a delivery end date" do
    no_due_ol = OrderList.new(@attr.merge(:delivery_end => nil))
    no_due_ol.should_not be_valid
  end
   
   it "should require a user" do 
     no_user_ol = OrderList.new(@attr.merge(:user => nil))
     no_user_ol.should_not be_valid
  end
  
  it "should reject start dates that are in the past" do
    ol = OrderList.new(@attr.merge(:order_start => Time.now - 1.day))
    ol.should_not be_valid
  end
  
  it "should reject end dates that are prior to the start date" do
    ol = OrderList.new(@attr.merge(:order_end => @attr[:order_start] - 1.day))
    ol.should_not be_valid
  end
  
  it "should reject due dates that are prior to the end date" do 
    ol = OrderList.new(@attr.merge(:delivery_start => @attr[:order_end] - 1.day))
    ol.should_not be_valid
  end
  
  it "should reject delivery end dates that are prior to the delivery start date" do 
    ol = OrderList.new(@attr.merge(:delivery_end => @attr[:delivery_start] - 1.day))
    ol.should_not be_valid
  end
  
  it "should reject end dates that are equal to the start date" do
    ol = OrderList.new(@attr.merge(:order_end => @attr[:order_start]))
    ol.should_not be_valid
  end
  
  it "should reject due dates that are equal to the end date" do 
    ol = OrderList.new(@attr.merge(:delivery_start => @attr[:order_end]))
    ol.should_not be_valid
  end
  
  it "should reject delivery end dates that are equal to the delivery start date" do 
    ol = OrderList.new(@attr.merge(:delivery_end => @attr[:delivery_start]))
    ol.should_not be_valid
  end
  
  it "should build an orderlist based on the defaults for the market" do
    @market = Market.the_market
    #  start_day_of_week    :integer
    #  ordering_period      :integer
    #  due_date_day_of_week :integer
    #  due_date_hour        :integer
    #  due_date_period      :integer
    @market.start_day_of_week = 2    # tuesday
    @market.ordering_period = 1      # 1 day
    @market.due_date_day_of_week = 4 # thursday
    @market.due_date_hour = 7        # 7 am
    @market.due_date_period = 5      # 12pm
    ol = OrderList.new_for_market(@market)
  end
end
