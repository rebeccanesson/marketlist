class AddProductFamilyToOrderable < ActiveRecord::Migration
  def self.up
    add_column :orderables, :product_family, :integer
  end

  def self.down
    remove_column :orderables, :product_family
  end
end
