class CreateDownloads < ActiveRecord::Migration
  def self.up
    create_table :downloads do |t|
      t.boolean :active, :null => false
      t.boolean :approved, :null => false
      t.integer :created_by, :null => false
      t.integer :resource_id, :null => false
      t.string  :resource_type, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :downloads
  end
end
