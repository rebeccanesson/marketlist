class Address < ActiveRecord::Base
  belongs_to :user
  
  validates :street_1, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :zipcode, :presence => true
  
end
