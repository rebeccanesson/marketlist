class UpdateProducts < ActiveRecord::Migration
  def self.up
    rename_column :products, :organic_price, :base_organic_price
    rename_column :products, :conventional_price, :base_conventional_price
    add_column :products, :organic_status, :string, :default => "both"
  end

  def self.down
    rename_column :products, :base_organic_price, :organic_price
    rename_column :products, :base_conventional_price, :conventional_price
    remove_column :products, :organic_status
  end
end
