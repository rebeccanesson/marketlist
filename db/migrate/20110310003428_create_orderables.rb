class CreateOrderables < ActiveRecord::Migration
  def self.up
    create_table :orderables do |t|
      t.integer :product_id
      t.decimal :organic_price, :precision => 8, :scale => 2
      t.decimal :conventional_price, :precision => 8, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :orderables
  end
end
