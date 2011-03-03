class ChangeProductPricesToDecimal < ActiveRecord::Migration
  def self.up
    change_column :products, :base_conventional_price, :decimal, :precision => 8, :scale => 2
    change_column :products, :base_organic_price, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    change_column :product, :base_conventional_price, :integer
    change_column :product, :base_organic_price, :integer
  end
end
