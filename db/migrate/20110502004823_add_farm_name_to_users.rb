class AddFarmNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :farm_name, :string
  end

  def self.down
    remove_column :users, :farm_name
  end
end
