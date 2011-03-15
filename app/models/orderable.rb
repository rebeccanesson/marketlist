# == Schema Information
# Schema version: 20110310141355
#
# Table name: orderables
#
#  id                 :integer         not null, primary key
#  product_id         :integer
#  organic_price      :decimal(, )
#  conventional_price :decimal(, )
#  created_at         :datetime
#  updated_at         :datetime
#  order_listing_id   :integer
#

class Orderable < ActiveRecord::Base
  attr_accessible :product, :product_id, :organic_price, :conventional_price, :order_listing_id, :order_listing
  
  belongs_to :product
  belongs_to :order_listing
  has_one :order_list, :through => :order_listing
  
  validates :product, :presence => true
  # validates :order_listing, :presence => true
  
  validates :organic_price, :presence => true,
                            :if => Proc.new { |o| o.conventional_price == nil }
                            
  validates :conventional_price, :presence => true, 
                                 :if => Proc.new { |o| o.organic_price == nil }
                                 
  validates_numericality_of :organic_price, :allow_nil => true, 
                                            :greater_than => 0
                                            
  validates_numericality_of :conventional_price, :allow_nil => true, 
                                                 :greater_than => 0
  
end
