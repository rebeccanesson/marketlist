# == Schema Information
# Schema version: 20110303015133
#
# Table name: products
#
#  id                      :integer         not null, primary key
#  name                    :string(255)
#  description             :text(255)
#  base_organic_price      :decimal(, )
#  base_conventional_price :decimal(, )
#  created_at              :datetime
#  updated_at              :datetime
#  organic_status          :string(255)     default("both")
#

class Product < ActiveRecord::Base
   attr_accessible :name, :description, :base_organic_price, :base_conventional_price, :organic_status
   
   validates :name, :presence => true,
                    :length   => { :maximum => 50 }
  
   validates :description, :presence => true
                    
   ORGANIC_STATUSES = ['organic and conventional', 'organic only', 'conventional only', 'no organic premium']
   validates_inclusion_of :organic_status, :in => ORGANIC_STATUSES
   
   validates_numericality_of :base_organic_price, :only_integer => true, :greater_than => -1
   validates_numericality_of :base_conventional_price, :only_integer => true, :greater_than => -1
     
   
end
