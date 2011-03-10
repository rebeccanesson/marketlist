# == Schema Information
# Schema version: 20110310140259
#
# Table name: order_listings
#
#  id                :integer         not null, primary key
#  order_list_id     :integer
#  quantity          :integer
#  product_family_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class OrderListing < ActiveRecord::Base
  attr_accessible :order_list_id, :order_list, :product_family_id, :product_family, :quantity
  
  belongs_to :order_list
  belongs_to :product_family
  has_many   :orderables
  
  validates :order_list, :presence => true
  validates :product_family, :presence => true
  
  validates_numericality_of :quantity, :presence => true,
                                       :greater_than => 0
 

  
end
