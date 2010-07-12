class AddScoreToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :score, :integer
  end

  def self.down
    remove_column :posts, :score
  end
end
