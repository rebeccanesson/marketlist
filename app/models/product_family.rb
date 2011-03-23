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
  has_many :user_family_blocks, :dependent => :destroy
  
  validates :name, :presence => true,
                   :length   => { :maximum => 50 },
                   :uniqueness => {:case_sensitive => false}
                   
  def is_blocked_for_user(user)
    blocks_for_user = user_family_blocks.select { |ufb| ufb.user == user }
    puts "blocks for user #{user.id} are #{blocks_for_user}, size is #{blocks_for_user.size}"
    if blocks_for_user.size > 0 
      true
    else 
      false
    end
  end
  
  def is_available_for_user(user)
    !self.is_blocked_for_user(user)
  end
  
  def is_locked_for_user(user)
    blocks = user_family_blocks.select { |ufb| ufb.user == user }
    if blocks.size > 0 
      blocks.first.locked
    else 
      false
    end
  end
  
end
