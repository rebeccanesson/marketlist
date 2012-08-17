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
  
  after_create :create_invoice
  after_destroy :check_invoice
  
  validate :user_can_commit_to_product_family
  
  def quantity_in_allowed_range
   # self.errors.add(:quantity, "quantity is #{quantity} and available commitments is #{self.orderable.order_listing.total_commitments_available_to(self.user)}")
   self.errors.add(:quantity, " committed must be less than the quantity needed") unless quantity <= self.orderable.order_listing.total_commitments_available_to(self.user)
  end
  
  def user_can_commit_to_product_family
    self.errors.add(:user, " is not authorized to commit to products in the #{self.orderable.product.product_family.name} family") unless self.orderable.product.product_family.is_available_for_user(self.user)
  end
  
  def invoice
    i = Invoice.find(:first, :conditions => ["user_id = ? and order_list_id = ?", self.user.id, self.order_listing.order_list.id])
  end
   
  def create_invoice
    ivs = Invoice.find(:all, :conditions => ["user_id = ? and order_list_id = ?", self.user.id, self.order_listing.order_list.id])
    if ivs.size == 0 
      Invoice.create!(:user => self.user, :order_list => self.order_listing.order_list)
    end 
  end 
  
  def check_invoice
    if self.order_listing.order_list.commitments.select { |c| c.user == self.user }.size == 0
      invoice = Invoice.find(:first, :conditions => ["user_id = ? and order_list_id = ?", self.user.id, self.order_listing.order_list.id])
      invoice.destroy if invoice
    end
  end
  
  def price_for_user(user)
      puts "user #{user} orderable #{self.orderable} price #{self.orderable.price_for_user(user)} quantity #{self.quantity}"
    self.orderable.price_for_user(user) * self.quantity
  end
     
end
