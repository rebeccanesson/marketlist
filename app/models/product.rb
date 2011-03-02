# == Schema Information
# Schema version: 20110301221604
#
# Table name: products
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  description        :string(255)
#  organic_price      :integer
#  conventional_price :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class Product < ActiveRecord::Base
end
