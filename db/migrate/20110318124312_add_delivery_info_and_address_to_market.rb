class AddDeliveryInfoAndAddressToMarket < ActiveRecord::Migration
  def self.up
    add_column :markets, :delivery_info, :text
    add_column :markets, :address_1, :string
    add_column :markets, :address_2, :string
    add_column :markets, :city, :string
    add_column :markets, :state, :string
    add_column :markets, :zipcode, :string
    add_column :markets, :phone, :string
  end

  def self.down
    remove_column :markets, :delivery_info
    remove_column :markets, :address_1
    remove_column :markets, :address_2
    remove_column :markets, :city
    remove_column :markets, :state
    remove_column :markets, :zipcode
    remove_column :markets, :phone
  end
end
