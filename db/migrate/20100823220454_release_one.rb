class ReleaseOne < ActiveRecord::Migration
  def self.up
    create_table :pezez do |t|
      t.string  :identity, :null => false
      t.string  :colour, :null => false
      t.string  :status, :null => false  # waiting, seated
      t.integer :priority, :null => false
      t.string  :secret_code
      t.timestamps
    end
    
    create_table :users do |t|
      t.string   :identity, :null => false
      t.boolean  :admin, :default => 0
      t.string   :name
      t.string   :hashed_password
      t.string   :email
      t.string   :salt
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :pezez
    drop_table :users
  end
end
