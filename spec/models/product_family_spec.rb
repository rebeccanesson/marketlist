require 'spec_helper'

describe ProductFamily do
  before(:each) do
    @attr = { :name => "Tomatoes" }
  end
  
  it "should create a new instance given valid attributes" do
    ProductFamily.create!(@attr)
  end
  
  it "should require a name" do
    no_name = ProductFamily.new(@attr.merge(:name => nil))
    no_name.should_not be_valid
  end
  
  it "should reject duplicate names" do
    ProductFamily.create!(@attr)
    dup_name = ProductFamily.new(@attr)
    dup_name.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_fam = ProductFamily.new(@attr.merge(:name => long_name))
    long_name_fam.should_not be_valid
  end
  
  it "should reject names that are too short" do
    short_name = ""
    short_name_fam = ProductFamily.new(@attr.merge(:name => short_name))
    short_name_fam.should_not be_valid
  end
  
end

