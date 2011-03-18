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
  attr_accessible :order_list_id, :order_list, :product_family_id, :product_family, :quantity, :orderables_attributes, :orderables
  
  belongs_to :order_list
  belongs_to :product_family
  has_many   :orderables, :dependent => :destroy
  has_many   :commitments, :through => :orderables
  accepts_nested_attributes_for :orderables, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:product_id].blank? } 
  
  
  
  validates :order_list, :presence => true
  validates :product_family, :presence => true
  
  validates_numericality_of :quantity, :presence => true,
                                       :greater_than => 0
 

  # This is the total number (including the already claimed commitments) that a user can have
  def total_commitments_available_to(user)
    quantity - total_commitment_quantity + total_commitment_quantity_for_user(user)
  end
  
  def total_commitments_available
    quantity - total_commitment_quantity
  end
  
  def total_commitment_quantity
    self.commitments.inject(0) { |sum,c| sum + c.quantity }
  end
  
  def total_commitment_quantity_for_user(user)
    self.commitments.select { |c| c.user == user }.inject(0) { |sum,c| sum + c.quantity }
  end
  
  def display_name 
    (!self.orderables.empty? ? self.product_family.name + ": " + self.orderables.collect{ |o| o.product.name }.join(" OR ") : 'No Products')
  end

end
