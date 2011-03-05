# == Schema Information
# Schema version: 20110304210140
#
# Table name: products
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  description       :text(255)
#  base_price        :decimal(, )
#  created_at        :datetime
#  updated_at        :datetime
#  organic           :boolean
#  product_family_id :integer
#

class Product < ActiveRecord::Base
  belongs_to :product_family
  
  attr_accessible :name, :description, :base_price, :organic, :product_family, :product_family_id
   
    
    
   validates :name, :presence => true,
                    :length   => { :maximum => 50 }
  
   validates :description, :presence => true
   
   validates :product_family, :presence => true 
   
   validates_numericality_of :base_price, :greater_than => -1     
   
  
   
end
