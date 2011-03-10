# == Schema Information
# Schema version: 20110310014142
#
# Table name: orderables
#
#  id                 :integer         not null, primary key
#  product_id         :integer
#  organic_price      :decimal(8, 2)
#  conventional_price :decimal(8, 2)
#  created_at         :datetime
#  updated_at         :datetime
#  order_list_id      :integer
#

class Orderable < ActiveRecord::Base
  attr_accessible :product, :product_id, :organic_price, :conventional_price, :order_list_id, :order_list
  
  belongs_to :product
  belongs_to :order_list
  
  validates :product, :presence => true
  validates :order_list, :presence => true
  
  validates :organic_price, :presence => true,
                            :if => Proc.new { |o| o.conventional_price == nil }
                            
  validates :conventional_price, :presence => true, 
                                 :if => Proc.new { |o| o.organic_price == nil }
                                 
  validates_numericality_of :organic_price, :allow_nil => true, 
                                            :greater_than => 0
                                            
  validates_numericality_of :conventional_price, :allow_nil => true, 
                                                 :greater_than => 0
  
end
