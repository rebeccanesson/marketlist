require 'spec_helper'

describe Market do
  before(:each) do
    @attr = { :name => "Company Shops Market", 
              :description => "Your local food co-op in Burlington, NC", 
              :contact_email => "rebeccanesson@gmail.com" }
  end
  
  it "should create a new instance given valid attributes" do
    Market.create!(@attr)
  end
  
  it "should require a name" do
    no_name_mark = Market.new(@attr.merge(:name => ""))
    no_name_mark.should_not be_valid
  end
  
  it "should require a description" do
    no_desc_mark = Market.new(@attr.merge(:description => ""))
    no_desc_mark.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_mark = Market.new(@attr.merge(:name => long_name))
    long_name_mark.should_not be_valid
  end 
  
  it "should reject negative start day of week" do 
    mark = Market.new(@attr.merge(:start_day_of_week => -1))
    mark.should_not be_valid
  end
  
  it "should reject larger than 6 start day of week" do 
    mark = Market.new(@attr.merge(:start_day_of_week => 7))
    mark.should_not be_valid
  end
  
  it "should reject negative due day of week" do 
    mark = Market.new(@attr.merge(:due_date_day_of_week => -1))
    mark.should_not be_valid
  end
  
  it "should reject larger than 6 due day of week" do 
    mark = Market.new(@attr.merge(:due_date_day_of_week => 7))
    mark.should_not be_valid
  end
  
  it "should reject negative or 0 ordering period" do 
    mark = Market.new(@attr.merge(:ordering_period => 0))
    mark.should_not be_valid
  end
  
  it "should reject negative or 0 due date period" do 
    mark = Market.new(@attr.merge(:due_date_period => 0))
    mark.should_not be_valid
  end
  
  it "should get a default market object" do 
    mark = Market.the_market
    mark.should_not be_nil
  end 
  
  
end
