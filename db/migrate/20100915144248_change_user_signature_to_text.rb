class ChangeUserSignatureToText < ActiveRecord::Migration
  def self.up
    change_column(:users, :signature, :text)
    change_column(:users, :signature_html, :text)
  end

  def self.down
    change_column(:users, :signature, :string)
    change_column(:users, :signature_html, :string)
  end
end
