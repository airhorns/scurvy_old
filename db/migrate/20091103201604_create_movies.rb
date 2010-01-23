class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :title, :null => false
      t.integer :year
      t.string :director
      t.string :imdbid
      t.decimal :imdbrating
      t.string :posterurl
      t.text :synopsis
      t.text :tagline
      t.integer :length
      t.string :language
      t.boolean :autogenerated
      
      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end