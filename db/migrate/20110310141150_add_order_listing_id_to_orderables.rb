class AddOrderListingIdToOrderables < ActiveRecord::Migration
  def self.up
    add_column :orderables, :order_listing_id, :integer
  end

  def self.down
    remove_column :orderables, :order_listing_id
  end
end
