class UpdatePostScore < ActiveRecord::Migration
  def self.up
    Post.update_all("score = 1")
  end

  def self.down
  end
end
