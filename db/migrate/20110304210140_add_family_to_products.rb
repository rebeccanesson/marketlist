class AddFamilyToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :product_family_id, :integer
  end

  def self.down
    remove_column :producs, :product_family_id
  end
end
