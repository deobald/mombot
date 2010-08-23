class ReleaseOne < ActiveRecord::Migration
  def self.up
    create_table :pezez do |t|
      t.string :identity, :null => false
      t.string :colour, :null => false
    end
  end

  def self.down
  end
end
