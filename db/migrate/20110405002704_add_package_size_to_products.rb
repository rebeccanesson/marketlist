class AddPackageSizeToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :package_size, :string
  end

  def self.down
    remove_column :products, :package_size
  end
end
