class CreateFloaters < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.string :type
      t.integer :batch_number
      t.string :guess
    end
    Location.update_all(:type => "Location")
  end

  def self.down
    remove_column :locations, :batch_number
    remove_column :locations, :guess
  end
end
