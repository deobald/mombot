class ReleaseOne < ActiveRecord::Migration
  def self.up
    create_table :pezez do |t|
      t.string  :identity, :null => false
      t.string  :colour, :null => false
      t.integer :priority
      t.timestamps
    end
  end

  def self.down
    drop_table :pezez
  end
end
