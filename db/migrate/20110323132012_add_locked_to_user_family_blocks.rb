class AddLockedToUserFamilyBlocks < ActiveRecord::Migration
  def self.up
     add_column :user_family_blocks, :locked, :boolean, :default => false
  end

  def self.down
    remove_column :user_family_blocks, :locked
  end
end
