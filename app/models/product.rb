# == Schema Information
# Schema version: 20110322131246
#
# Table name: products
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  description       :text(255)
#  created_at        :datetime
#  updated_at        :datetime
#  product_family_id :integer
#  plu_number        :string(255)
#

require "fastercsv"
class Product < ActiveRecord::Base
  belongs_to :product_family
  has_many :orderables, :dependent => :destroy
  
  attr_accessible :name, :description, :product_family, :product_family_id, :plu_number
   
    
    
   validates :name, :presence => true,
                    :length   => { :maximum => 50 }
  
   validates :description, :presence => true
   
   validates :product_family, :presence => true    
   
   validates :plu_number, :uniqueness => true, 
                          :allow_nil => true
   
  
                          
    def self.create_from_csv(upload)
      name =  upload['datafile'].original_filename
      directory = "public/data"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
      success = []
      failure = []
      FasterCSV.foreach(path) do |row|
        puts "row is #{row}"
        plu = row[2]
        if (plu and !plu.blank?)
          prod = Product.find_by_plu_number(plu) || Product.new(:plu_number => row[2])
        else 
          prod = Product.new
        end
        pf = ProductFamily.find_by_name(row[0]) || ProductFamily.create!(:name => row[0])
        prod.product_family_id = pf.id
        prod.name = row[1]
        prod.description = row[3] 
        if prod.save!
          success << prod.name
        else
          failure << prod.errors
        end
      end
      File.delete(path)
      [success,failure]
    end
end
