class AddOrganicToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :organic, :boolean, :default => false
  end

  def self.down
    remove_column :users, :organic
  end
end
