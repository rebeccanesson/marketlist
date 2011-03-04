class AlterMarketsToChangeDescriptionToText < ActiveRecord::Migration
  def self.up
    change_column :markets, :description, :text
  end

  def self.down
    change_column :markets, :description, :string
  end
end
