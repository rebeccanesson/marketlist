class RemoveOrderListingFromCommitments < ActiveRecord::Migration
  def self.up
    remove_column :commitments, :order_listing_id
  end

  def self.down
    add_column :commitments, :order_listing_id, :integer
  end
end
