class RemoveProductFamilyFromOrderables < ActiveRecord::Migration
  def self.up
    remove_column :orderables, :product_family
  end

  def self.down
    add_column :orderables, :product_family, :integer
  end
end
