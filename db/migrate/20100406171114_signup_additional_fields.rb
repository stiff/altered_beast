class SignupAdditionalFields < ActiveRecord::Migration
  def self.up
    create_table :responsabilities, :force => true do |t|
      t.string :description
    end
    Responsability.create!(:description => "desenvolvimento")
    Responsability.create!(:description => "liderança ou arquitetura de equipe")
    Responsability.create!(:description => "quality assurance (QA) ou testes")
    Responsability.create!(:description => "líder técnico ou arquiteto geral")
    Responsability.create!(:description => "product owner")
    Responsability.create!(:description => "outro")
    
    
    create_table :company_sizes, :force => true do |t|
      t.string :description
    end
    CompanySize.create(:description => "1 a 10")
    CompanySize.create(:description => "11 a 50")
    CompanySize.create(:description => "51 a 500")
    CompanySize.create(:description => "501 ou mais")

    create_table :locals, :force => true do |t|
      t.string :name
      t.timestamps
      t.string :city
      t.string :states
    end
    
    ActiveRecord::Base.connection.update(File.open('cities.sql').read)
    
    add_column :users, :responsability_id, :integer
    add_column :users, :company_size_id, :integer
    add_column :users, :local_id, :integer
    add_column :users, :working_since, :integer
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
