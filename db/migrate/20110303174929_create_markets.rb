class CreateMarkets < ActiveRecord::Migration
  def self.up
    create_table :markets do |t|
      t.string :name
      t.string :description
      t.string :contact_email
      t.string :logo_url
      t.integer :start_day_of_week
      t.integer :ordering_period
      t.integer :due_date_day_of_week
      t.integer :due_date_hour
      t.integer :due_date_period

      t.timestamps
    end
  end

  def self.down
    drop_table :markets
  end
end
