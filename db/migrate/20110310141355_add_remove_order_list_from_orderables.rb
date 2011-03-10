class AddRemoveOrderListFromOrderables < ActiveRecord::Migration
  def self.up
    remove_column :orderables, :order_list_id
  end

  def self.down
    add_column :orderables, :order_list_id, :integer
  end
end
