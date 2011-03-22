class AddPluToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :plu_number, :string
  end

  def self.down
    remove_column :products, :plu_number
  end
end
