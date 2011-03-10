class RemoveBasePriceAndOrganicFromProduct < ActiveRecord::Migration
  def self.up
    remove_column :products, :base_price
    remove_column :products, :organic
  end

  def self.down
    add_column :products, :organic, :boolean
    add_column :products, :base_price, :decimal
  end
end
