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
  has_many :order_listings, :dependent => :destroy
  accepts_nested_attributes_for :order_listings, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:quantity].blank? } 
  has_many :invoices
  
  attr_accessible :user, :order_start, :order_end, :delivery_start, :delivery_end, :order_listings_attributes
  
  validates :order_start, :presence => true
  validates :order_end, :presence => true
  validates :delivery_start, :presence => true
  validates :delivery_end, :presence => true
  validates :user, :presence => true
  
  validates_is_after :order_start, :after => Time.zone.now.beginning_of_day - 1.hour
  validates_is_after :order_end, :after => :order_start
  # validates_is_after :delivery_start, :after => :order_end
  validates_is_after :delivery_end, :after => :delivery_start
  
  has_many :orderables, :through => :order_listings
  
  def self.active
    where("delivery_end >= ?", Time.now).order("order_start DESC")
  end
  
  def self.inactive
    where("delivery_end < ?", Time.now).order("order_start DESC")
  end
  
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
  
  def active? 
    Time.now <= delivery_end
  end 
  
  def order_open?
    order_start <= Time.now and Time.now <= order_end
  end
  
  def between_order_and_delivery? 
    order_end < Time.now and Time.now <= delivery_start
  end
  
  def invoice_for_user(user)
    is = invoices.select { |i| i.user == user}
    if !is.empty? 
      is.first
    else
      nil
    end
  end  
  
  def order_listings_for_user(user)
    self.order_listings.select { |ol| ol.product_family.is_available_for_user(user) }
  end
  
  def duplicate_for_market(market)
    dup = OrderList.new_for_market(market)
    dup.user = self.user
    dup.save!
    self.order_listings.each do |ol|
      dup_ol = OrderListing.new(:quantity => ol.quantity, :product_family => ol.product_family, :order_list => dup)
      dup_ol.save!
      ol.orderables.each do |ord|
        dup_ord = Orderable.new(:product => ord.product, :organic_price => ord.organic_price, :conventional_price => ord.conventional_price, :order_listing => dup_ol)
        dup_ord.save! 
      end
    end
    dup
  end
  
  def order_listing_for_product(product)
    OrderListing.find(:first, :joins => "inner join orderables on orderables.order_listing_id = order_listings.id", 
                              :conditions => ["order_listings.order_list_id = ? and orderables.product_id = ?", self.id, product.id]) 
  end 
  
  def order_listings_for_family(product_family)
    OrderListing.find(:all, :conditions => ["order_listings.order_list_id = ? and order_listings.product_family_id = ?", self.id, product_family.id])
  end
  
end
