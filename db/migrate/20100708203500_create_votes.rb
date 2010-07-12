class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.references :post
      t.references :user
      t.integer :value, :null => false, :default => 1

      t.timestamps
    end
    
    add_index :votes, [ :post_id, :user_id ], :unique => true
  end

  def self.down
    drop_table :votes
  end
end
