# == Schema Information
# Schema version: 20110318124312
#
# Table name: markets
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  description          :text(255)
#  contact_email        :string(255)
#  logo_url             :string(255)
#  start_day_of_week    :integer
#  order_start_hour     :integer
#  ordering_period      :integer
#  due_date_day_of_week :integer
#  due_date_hour        :integer
#  due_date_period      :integer
#  created_at           :datetime
#  updated_at           :datetime
#  delivery_info        :text
#  address_1            :string(255)
#  address_2            :string(255)
#  city                 :string(255)
#  state                :string(255)
#  zipcode              :string(255)
#  phone                :string(255)
#

class Market < ActiveRecord::Base
  attr_accessible :name, :description, :contact_email, :logo_url, :start_day_of_week,
                  :ordering_period, :due_date_day_of_week, :due_date_hour, :due_date_period, 
                  :delivery_info, :address_1, :address_2, :city, :state, :zipcode, :phone, 
                  :order_list_email_intro, :order_start_hour
  
  validates :name, :presence => true,
                   :length => {:maximum => 50}
                   
  validates :description, :presence => true
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :contact_email, :presence => true, 
                            :format => {:with => email_regex}
                            
  validates_numericality_of :start_day_of_week, :allow_nil => true, 
                                                :greater_than_or_equal_to => 0, 
                                                :less_than => 7
                                                
  validates_numericality_of :ordering_period, :allow_nil => true, 
                                              :greater_than_or_equal_to => 1
                                              
  validates_numericality_of :due_date_day_of_week, :allow_nil => true, 
                                                   :greater_than_or_equal_to => 0, 
                                                   :less_than => 7
  
  validates_numericality_of :due_date_hour, :allow_nil => true, 
                                            :greater_than_or_equal_to => 0, 
                                            :less_than => 24
                                            
  validates_numericality_of :due_date_period, :allow_nil => true, 
                                              :greater_than_or_equal_to => 1
                                              
  validates_numericality_of :order_start_hour, :allow_nil => true, 
                                                :greater_than_or_equal_to => 0, 
                                                :less_than => 24
                            
                        
                    
                                     
  def self.the_market
    @market = Market.first || Market.create!(:name => "Default Market", :description => "About the market", 
                                             :contact_email => "foo@example.com", :logo_url => "/public/images/logo.jpg")
  end
  
end
