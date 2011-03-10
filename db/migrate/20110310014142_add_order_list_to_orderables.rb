class AddOrderListToOrderables < ActiveRecord::Migration
  def self.up
    add_column :orderables, :order_list_id, :integer
  end

  def self.down
    remove_column :orderables, :order_list_id
  end
end
