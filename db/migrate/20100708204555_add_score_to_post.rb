class AddScoreToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :score, :integer, :null => false, :default => 1
  end

  def self.down
    remove_column :posts, :score
  end
end
