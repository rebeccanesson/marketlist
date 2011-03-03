class CreateOrderLists < ActiveRecord::Migration
  def self.up
    create_table :order_lists do |t|
      t.integer :user_id
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :due_date

      t.timestamps
    end
  end

  def self.down
    drop_table :order_lists
  end
end
