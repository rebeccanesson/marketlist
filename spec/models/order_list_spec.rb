require 'spec_helper'

describe OrderList do
  before(:each) do
    @attr = { :start_date => Time.now + 3.days, 
              :end_date => Time.now + 5.days, 
              :due_date => Time.now + 8.days, 
              :user => Factory(:user)
            }
  end
  
  it "should create a new instance given valid attributes" do
    OrderList.create!(@attr)
  end
  
  it "should require a start date" do
    no_start_ol = OrderList.new(@attr.merge(:start_date => nil))
    no_start_ol.should_not be_valid
  end
  
  it "should require an end date" do
    no_end_ol = OrderList.new(@attr.merge(:end_date => nil))
    no_end_ol.should_not be_valid
  end
  
  it "should require a due date" do
    no_due_ol = OrderList.new(@attr.merge(:due_date => nil))
    no_due_ol.should_not be_valid
  end
   
   it "should require a user" do 
     no_user_ol = OrderList.new(@attr.merge(:user => nil))
     no_user_ol.should_not be_valid
  end
  
  it "should reject start dates that are in the past" do
    ol = OrderList.new(@attr.merge(:start_date => Time.now - 1.day))
    ol.should_not be_valid
  end
  
  it "should reject end dates that are prior to the start date" do
    ol = OrderList.new(@attr.merge(:end_date => @attr[:start_date] - 1.day))
    ol.should_not be_valid
  end
  
  it "should reject due dates that are prior to the end date" do 
    ol = OrderList.new(@attr.merge(:due_date => @attr[:end_date] - 1.day))
    ol.should_not be_valid
  end
  
  it "should reject end dates that are equal to the start date" do
    ol = OrderList.new(@attr.merge(:end_date => @attr[:start_date]))
    ol.should_not be_valid
  end
  
  it "should reject due dates that are equal to the end date" do 
    ol = OrderList.new(@attr.merge(:due_date => @attr[:end_date]))
    ol.should_not be_valid
  end
end
