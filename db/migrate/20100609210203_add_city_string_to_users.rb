class AddCityStringToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :city, :string
  end

  def self.down
    remove_column :users, :city
  end
end
