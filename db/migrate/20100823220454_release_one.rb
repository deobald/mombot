class ReleaseOne < ActiveRecord::Migration
  def self.up
    create_table :pezez do |t|
      t.string  :identity, :null => false
      t.string  :colour, :null => false
      t.string  :status, :null => false  # waiting, seated, dispensed, rejected
      t.integer :priority
      t.string  :secret_code
      t.timestamps
    end
    
    create_table :images do |t|
      t.integer :pez_id
      t.integer :size
      t.string  :content_type
      t.string  :filename
      t.integer :height
      t.integer :width
      t.timestamps
    end
    
    create_table :users do |t|
      t.string   :identity, :null => false
      t.boolean  :admin, :default => 0
      t.string   :name
      t.string   :hashed_password
      t.string   :email
      t.string   :salt
      t.timestamps
    end
    
    create_table :votes do |t|
      t.integer  :pez_id, :null => false
      t.integer  :user_id, :null => false
      t.boolean  :approve, :null => false
      t.timestamps
    end
    
    create_table :things do |t|
      t.integer  :user_id, :null => false
      t.integer  :previous_id
      t.string   :title, :null => false
      t.string   :url
      t.string   :body
      t.timestamps
    end
  end

  def self.down
    drop_table :pezez
    drop_table :images
    drop_table :users
    drop_table :votes
    drop_table :things
  end
end
