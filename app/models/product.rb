# == Schema Information
# Schema version: 20110310000235
#
# Table name: products
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  description       :text(255)
#  created_at        :datetime
#  updated_at        :datetime
#  product_family_id :integer
#

class Product < ActiveRecord::Base
  belongs_to :product_family
  has_many :orderables
  
  attr_accessible :name, :description, :product_family, :product_family_id
   
    
    
   validates :name, :presence => true,
                    :length   => { :maximum => 50 }
  
   validates :description, :presence => true
   
   validates :product_family, :presence => true     
   
  
   
end
