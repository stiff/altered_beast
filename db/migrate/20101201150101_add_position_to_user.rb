class AddPositionToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :position, :string
  end

  def self.down
    remove_column :users, :position
  end
end
