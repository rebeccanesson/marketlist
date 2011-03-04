# == Schema Information
# Schema version: 20110304010743
#
# Table name: order_lists
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  order_start    :datetime
#  order_end      :datetime
#  delivery_start :datetime
#  created_at     :datetime
#  updated_at     :datetime
#  delivery_end   :datetime
#

class OrderList < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :user, :order_start, :order_end, :delivery_start, :delivery_end
  
  validates :order_start, :presence => true
  validates :order_end, :presence => true
  validates :delivery_start, :presence => true
  validates :delivery_end, :presence => true
  validates :user, :presence => true
  
  validates_is_after :order_start
  validates_is_after :order_end, :after => :order_start
  validates_is_after :delivery_start, :after => :order_end
  validates_is_after :delivery_end, :after => :delivery_start
  
  def self.new_for_market(market)
    OrderList.new
  end
  
end
