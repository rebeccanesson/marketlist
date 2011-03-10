class CreateOrderListings < ActiveRecord::Migration
  def self.up
    create_table :order_listings do |t|
      t.integer :order_list_id
      t.integer :quantity
      t.integer :product_family_id

      t.timestamps
    end
  end

  def self.down
    drop_table :order_listings
  end
end
