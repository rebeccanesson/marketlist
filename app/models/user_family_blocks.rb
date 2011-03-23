# == Schema Information
# Schema version: 20110323010031
#
# Table name: user_family_blocks
#
#  id                :integer         not null, primary key
#  user_id           :integer
#  product_family_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class UserFamilyBlocks < ActiveRecord::Base
  attr_accessible :user, :user_id, :product_family, :product_family_id
  
  belongs_to :user
  belongs_to :product_family
  
  validates :user_id, :presence => true
  validates :product_family, :presence => true
end
