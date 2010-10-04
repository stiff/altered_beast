class AddReceiveMailling < ActiveRecord::Migration
  def self.up
    add_column :users, :receive_mailing, :boolean, :default => true

    User.update_all({:receive_mailing => true}, {:receive_mailing => nil})
  end

  def self.down
    remove_column :users, :receive_mailing
  end
end
