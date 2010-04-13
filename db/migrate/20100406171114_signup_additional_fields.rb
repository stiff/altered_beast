class SignupAdditionalFields < ActiveRecord::Migration
  def self.up
    create_table :responsabilities, :force => true do |t|
      t.string :description
    end
    
    create_table :company_sizes, :force => true do |t|
      t.string :description
    end
    create_table :locals, :force => true do |t|
      t.string :name
      t.timestamps
      t.string :city
      t.string :states
    end
    
    add_column :users, :responsability_id, :integer
    add_column :users, :company_size_id, :integer
    add_column :users, :local_id, :integer
    add_column :users, :working_since, :integer
    
    Rake::Task["app:load_database"].invoke
  end

  def self.down
    remove_column :users, :working_since
    remove_column :users, :local_id
    remove_column :users, :company_size_id
    remove_column :users, :responsability_id
    drop_table :responsabilities
    drop_table :company_sizes
    drop_table :locals
  end
end
