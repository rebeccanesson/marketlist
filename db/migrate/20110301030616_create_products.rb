class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :organic_price
      t.integer :conventional_price

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
