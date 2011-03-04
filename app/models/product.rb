# == Schema Information
# Schema version: 20110303143239
#
# Table name: products
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text(255)
#  base_price  :decimal(, )
#  created_at  :datetime
#  updated_at  :datetime
#  organic     :boolean
#

class Product < ActiveRecord::Base
   attr_accessible :name, :description, :base_price, :organic
   
   validates :name, :presence => true,
                    :length   => { :maximum => 50 }
  
   validates :description, :presence => true
   
   validates_numericality_of :base_price, :greater_than => -1     
   
end
