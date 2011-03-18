class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.integer :user_id
      t.integer :order_list_id

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
