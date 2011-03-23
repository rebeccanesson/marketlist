class CreateUserFamilyBlocks < ActiveRecord::Migration
  def self.up
    create_table :user_family_blocks do |t|
      t.integer :user_id
      t.integer :product_family_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_family_blocks
  end
end
