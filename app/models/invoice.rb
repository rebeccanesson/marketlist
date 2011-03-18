# == Schema Information
# Schema version: 20110317203930
#
# Table name: invoices
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  order_list_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Invoice < ActiveRecord::Base
  attr_accessible :user, :user_id, :order_list, :order_list_id
  
  belongs_to :user
  belongs_to :order_list
  
  validates :user, :presence => true
  validates :order_list, :presence => true
  
  def commitments
    self.order_list.commitments.select { |c| c.user == self.user }
  end

  def total_price
    self.commitments.inject(0) { |sum, comm| sum + comm.price_for_user(self.user) }
  end
  
  def final
    Time.now > self.order_list.order_end
  end
  
end
