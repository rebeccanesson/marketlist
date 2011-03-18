class AddContactInformationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :address_1, :string
    add_column :users, :address_2, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zipcode, :string
    add_column :users, :phone, :string
  end

  def self.down
    remove_column :users, :address_1
    remove_column :users, :address_2
    remove_column :users, :city
    remove_column :users, :state
    remove_column :users, :zipcode
    remove_column :users, :phone
  end
end
