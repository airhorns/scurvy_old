class CreateReleases < ActiveRecord::Migration
  def self.up
    create_table :releases do |t|
      t.integer :download_id, :null => false
      t.integer :release_type_id, :null => false, :default => 0
      t.string :root_path
      t.text :notes

      t.timestamps
    end
    
    create_table :release_types do |t|
      t.string :name, :null => false
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
