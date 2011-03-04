class AlterOrderList < ActiveRecord::Migration
  def self.up
    rename_column :order_lists, :start_date, :order_start
    rename_column :order_lists, :end_date, :order_end
    rename_column :order_lists, :due_date, :delivery_start
    add_column    :order_lists, :delivery_end, :datetime
  end

  def self.down
    rename_column :order_lists, :order_start, :start_date
    rename_column :order_lists, :order_end, :end_date
    rename_column :order_lists, :delivery_start, :due_date
    remove_column :order_lists, :delivery_end
  end
end
