class AddSignatureToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :signature, :string, :null => false, :default => ""
    add_column :users, :signature_html, :string, :null => false, :default => ""
  end

  def self.down
    remove_column :users, :signature
  end
end
