class AddScoreToTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :score, :integer, :null => false, :default => 1
  end

  def self.down
    remove_column :topics, :score
  end
end
