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
  has_many :order_listings
  has_many :invoices
  
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
  
  has_many :orderables
  
  def self.new_for_market(market)
    ol = OrderList.new
    if (market.start_day_of_week and market.ordering_period and market.due_date_day_of_week and 
        market.due_date_hour and market.due_date_period)
      ol.order_start = (Time.zone.now + 1.day).beginning_of_day
      while ol.order_start.wday != market.start_day_of_week
        ol.order_start += 1.day
      end 
      ol.order_end = ol.order_start + market.ordering_period.days
      ol.delivery_start = ol.order_end + market.due_date_hour.hours
      while ol.delivery_start.wday != market.due_date_day_of_week
        ol.delivery_start += 1.day
      end
      ol.delivery_end = ol.delivery_start + market.due_date_period.hours
    end 
    ol
  end
  
  def commitments
    self.order_listings.collect { |ol| ol.commitments }.flatten
  end
  
end
