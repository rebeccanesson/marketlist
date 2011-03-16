class CreateCommitments < ActiveRecord::Migration
  def self.up
    create_table :commitments do |t|
      t.integer :order_listing_id
      t.integer :orderable_id
      t.integer :user_id
      t.integer :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :commitments
  end
end
