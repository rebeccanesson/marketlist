# == Schema Information
# Schema version: 20110303020451
#
# Table name: order_lists
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  start_date :datetime
#  end_date   :datetime
#  due_date   :datetime
#  created_at :datetime
#  updated_at :datetime
#

class OrderList < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :start_date, :user, :end_date, :due_date
  
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :due_date, :presence => true
  
  validates_is_after :start_date
  validates_is_after :end_date, :after => :start_date
  validates_is_after :due_date, :after => :end_date
end
