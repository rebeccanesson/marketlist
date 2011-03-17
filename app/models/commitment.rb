# == Schema Information
# Schema version: 20110316001956
#
# Table name: commitments
#
#  id           :integer         not null, primary key
#  orderable_id :integer
#  user_id      :integer
#  quantity     :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Commitment < ActiveRecord::Base
  attr_accessible :id, :order_listing_id, :order_listing, :orderable_id, :orderable, :user_id, :user, :quantity
  
  belongs_to :orderable
  has_one :order_listing, :through => :orderable
  belongs_to :user
  
  validates :orderable, :presence => true
  validates :user, :presence => true
  
  validates_numericality_of :quantity, :presence => true, 
                                       :greater_than => 0
                                       
  validate :quantity_in_allowed_range, :if => Proc.new { |o| o.orderable and o.user and o.quantity }
  
   def quantity_in_allowed_range
     # self.errors.add(:quantity, "quantity is #{quantity} and available commitments is #{self.orderable.order_listing.total_commitments_available_to(self.user)}")
     self.errors.add(:quantity, " committed must be less than the quantity needed") unless quantity <= self.orderable.order_listing.total_commitments_available
   end

end
