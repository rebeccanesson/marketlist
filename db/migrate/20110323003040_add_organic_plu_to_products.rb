class AddOrganicPluToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :organic_plu_number, :string
  end

  def self.down
    remove_column :products, :organic_plu_number
  end
end
