class RemoveAddressDataFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :address_1
    remove_column :users, :address_2
    remove_column :users, :city
    remove_column :users, :state
    remove_column :users, :zipcode
    add_column :users, :address_id, :integer
    add_column :users, :farm_address_id, :integer
  end

  def self.down
    add_column :users, :address_1, :string
    add_column :users, :address_2, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zipcode, :string
  end
end
