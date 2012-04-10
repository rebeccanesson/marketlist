class AddOrderStartHourToMarket < ActiveRecord::Migration
  def self.up
    add_column :markets, :order_start_hour, :integer
  end

  def self.down
    remove_column :markets, :order_start_hour
  end
end
