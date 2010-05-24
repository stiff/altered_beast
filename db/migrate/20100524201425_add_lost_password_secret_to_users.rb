class AddLostPasswordSecretToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :lost_password_secret, :string
  end

  def self.down
    remove_column :users, :lost_password_secret
  end
end
