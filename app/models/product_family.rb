# == Schema Information
# Schema version: 20110304210140
#
# Table name: product_families
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ProductFamily < ActiveRecord::Base
  attr_accessible :name
  
  has_many :products, :dependent => :destroy
  has_many :user_family_blocks
  
  validates :name, :presence => true,
                   :length   => { :maximum => 50 },
                   :uniqueness => {:case_sensitive => false}
                   
end
