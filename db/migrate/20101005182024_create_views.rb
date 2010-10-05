class CreateViews < ActiveRecord::Migration
  def self.up
    create_table :views do |t|
      t.integer :topic_id
      t.timestamps
    end
    
    Topic.all.each do |topic|
      topic.hits.times{|hits| View.create(:topic_id => topic.id)}
    end
  end

  def self.down
    drop_table :views
  end
end
