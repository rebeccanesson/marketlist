class ChangeAssociationOfUsersToAddresses < ActiveRecord::Migration
  def self.up
    remove_column :users, :address_id
    remove_column :users, :farm_address_id
    add_column :addresses, :user_id, :integer
  end

  def self.down
    add_column :users, :address_id, :integer
    add_column :users, :farm_address_id, :integer
    remove_column :addresses, :user_id
  end
  
end
