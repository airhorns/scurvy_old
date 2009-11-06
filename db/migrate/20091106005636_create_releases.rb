class CreateReleases < ActiveRecord::Migration
  def self.up
    create_table :releases do |t|
      t.integer :download_id
      t.integer :release_type
      t.text :notes

      t.timestamps
    end
    
    create_table :release_types do |t|
      t.string :type
      t.string :description
      t.string :applies_to

      t.timestamps
    end
  end

  def self.down
    drop_table :releases
    drop_table :release_types
  end
end
