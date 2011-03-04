class AlterProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :base_conventional_price
    rename_column :products, :base_organic_price, :base_price
    remove_column :products, :organic_status
    add_column :products, :organic, :boolean, :default => false
  end

  def self.down
    add_column :products, :base_conventional_price, :decimal, :precision => 8, :scale => 2
    rename_column :products, :base_price, :base_organic_price
    add_column :products, :organic_status, :string
    remove_column :products, :organic
  end
end
