class CreateDownloads < ActiveRecord::Migration
  def self.up
    create_table :downloads do |t|
      t.boolean :active
      t.boolean :approved
      t.integer :created_by
      t.integer :resource_id
      t.string  :resource_type
      
      t.timestamps
    end
  end

  def self.down
    drop_table :downloads
  end
end
