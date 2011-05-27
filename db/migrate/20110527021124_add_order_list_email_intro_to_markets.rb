class AddOrderListEmailIntroToMarkets < ActiveRecord::Migration
  def self.up
    add_column :markets, :order_list_email_intro, :text
  end

  def self.down
    remove_column :markets, :order_list_email_intro
  end
end
