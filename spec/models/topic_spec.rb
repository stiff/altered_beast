require File.dirname(__FILE__) + '/../spec_helper'

describe Topic do
  define_models

  it "updates forum_id for posts when topic forum is changed" do
    pending('Causing SQLite3::SQLException') if Topic.connection.class.name =~ /sqlite/i
    topics(:default).update_attribute :forum, forums(:other)
    posts(:default).reload.forum.should == forums(:other)
  end
  
  it "leaves other topic post #forum_ids alone when updating forum" do
    pending('Causing SQLite3::SQLException') if Topic.connection.class.name =~ /sqlite/i
    topics(:default).update_attribute :forum, forums(:other)
    posts(:other).reload.forum.should == forums(:default)
  end
  
  it "doesn't update last_updated_at when updating topic" do
    current_date = topics(:default).last_updated_at
    topics(:default).last_updated_at.should == current_date
  end

  [:title, :user_id, :forum_id].each do |attr|
    it "validates presence of #{attr}" do
      t = new_topic(:default)
      t.send("#{attr}=", nil)
      t.should_not be_valid
      t.errors.on(attr).should_not be_nil
    end
  end
  
  it "selects posts" do
    topics(:default).posts.should == [posts(:default)]
  end

  it "creates unsticky topic by default" do
    t = new_topic(:default)
    t.body = 'foo'
    t.sticky = nil
    t.save!
    t.should_not be_new_record
    t.should_not be_sticky
  end
  
  it "recognizes '1' as sticky" do
    topics(:default).should_not be_sticky
    topics(:default).sticky = 1
    topics(:default).should be_sticky
  end

  it "#hit! increments hits counter" do
    lambda { topics(:default).hit! }.should change { topics(:default).reload.hits }.by(1)
  end
  
  it "should know paged? status" do
    topics(:default).posts_count = 0
    topics(:default).should_not be_paged
    topics(:default).posts_count = Post.per_page + 5
    topics(:default).should be_paged
  end
  
  it "knows last page number based on posts count" do
    {0.0 => 1, 0.5 => 1, 1.0 => 1, 1.5 => 2}.each do |multiplier, last_page|
      topics(:default).posts_count = (Post.per_page.to_f * multiplier).ceil
      topics(:default).last_page.should == last_page
    end
  end
  
  it "doesn't allow new posts for locked topics" do
    @topic = topics(:default)
    @topic.locked = true ; @topic.save
    @post = @topic.user.reply @topic, 'booya'
    @post.should be_new_record
    @post.errors.on(:base).should == 'Topic is locked'
  end
  
  it "should change - for _" do
    topic = new_topic(:default)
    topic.title = "test with spaces"
    topic.nice_permalink.should == "test_with_spaces"
  end
  
end

describe Topic, "being deleted" do
  define_models

  before do
    @topic = topics(:default)
    @deleting_topic = lambda { @topic.destroy }
  end
  
  it "deletes posts" do
    post = posts(:default).reload
    @deleting_topic.call
    lambda { post.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end
  
  it "decrements Topic.count" do
    @deleting_topic.should change { Topic.count }.by(-1)
  end
  
  it "decrements Post.count" do
    @deleting_topic.should change { Post.count }.by(-1)
  end
  
  it "decrements cached forum topics_count" do
    @deleting_topic.should change { forums(:default).reload.topics_count }.by(-1)
  end
  
  it "decrements cached forum posts_count" do
    @deleting_topic.should change { forums(:default).reload.posts_count }.by(-1)
  end
  
  it "decrements cached site topics_count" do
    @deleting_topic.should change { sites(:default).reload.topics_count }.by(-1)
  end
  
  it "decrements cached site posts_count" do
    @deleting_topic.should change { sites(:default).reload.posts_count }.by(-1)
  end
  
  it "decrements cached user posts_count" do
    @deleting_topic.should change { users(:default).reload.posts_count }.by(-1)
  end
end

describe Topic, "being moved to another forum" do
  define_models
  
  before do
    @forum     = forums(:default)
    @new_forum = forums(:other)
    @topic     = topics(:default)
    @moving_forum = lambda { @topic.forum = @new_forum ; @topic.save! }
  end
  
  it "decrements old forums cached topics_count" do
    pending('Causing SQLite3::SQLException') if Topic.connection.class.name =~ /sqlite/i
    @moving_forum.should change { @forum.reload.topics.size }.by(-1)
  end
  
  it "decrements old forums cached posts_count" do
    pending('Causing SQLite3::SQLException') if Topic.connection.class.name =~ /sqlite/i
    @moving_forum.should change { @forum.reload.posts.size }.by(-1)
  end
  
  it "increments new forums cached topics_count" do
    pending('Causing SQLite3::SQLException') if Topic.connection.class.name =~ /sqlite/i
    @moving_forum.should change { @new_forum.reload.topics.size }.by(1)
  end
  
  it "increments new forums cached posts_count" do
    pending('Causing SQLite3::SQLException') if Topic.connection.class.name =~ /sqlite/i
    @moving_forum.should change { @new_forum.reload.posts.size }.by(1)
  end
  
  it "moves posts to new forum" do
    pending('Causing SQLite3::SQLException') if Topic.connection.class.name =~ /sqlite/i
    @topic.posts.each { |p| p.forum.should == @forum }
    @moving_forum.call
    @topic.posts.each { |p| p.reload.forum.should == @new_forum }
  end
end

describe Topic, "#editable_by?" do
  before do
    @user  = mock_model User
    @topic = Topic.new :forum => @forum
    @forum = mock_model(Forum)
  end

  it "restricts user for other topic" do
    @user.should_receive(:moderator_of?).and_return(false)
    @topic.should_not be_editable_by(@user)
  end

  it "allows user" do
    @topic.user_id = @user.id
    @user.should_receive(:moderator_of?).and_return(false)
    @topic.should be_editable_by(@user)
  end
  
  it "allows moderator" do
    @topic.should_receive(:forum).and_return(@forum)
    @user.should_receive(:moderator_of?).with(@forum).and_return(true)
    # @topic.forum_id = 2
    @topic.should be_editable_by(@user)
  end
end
