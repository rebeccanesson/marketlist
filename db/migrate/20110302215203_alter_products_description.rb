class AlterProductsDescription < ActiveRecord::Migration
  def self.up
    change_column :products, :description, :text
  end

  def self.down
    change_column :products, :description, :string
  end
end
