require File.dirname(__FILE__) + '/../spec_helper'

describe Post do
  define_models
  
  it "finds topic" do
    posts(:default).topic.should == topics(:default)
  end
  
  it "requires body" do
    p = new_post(:default)
    p.body = nil
    p.should_not be_valid
    p.errors.on(:body).should_not be_nil
  end

  it "formats body html" do
    p = Post.new :body => 'bar'
    p.body_html.should be_nil
    p.send :format_attributes
    p.body_html.should == '<p>bar</p>'
  end
    
end

describe Post, "being deleted" do
  define_models do
    model Post do
      stub :second, :body => 'second', :created_at => current_time - 6.days
    end
  end
  
  before do
    @deleting_post = lambda { posts(:default).destroy }
  end

  it "decrements cached forum posts_count" do
    @deleting_post.should change { forums(:default).reload.posts_count }.by(-1)
  end
  
  it "decrements cached site posts_count" do
    @deleting_post.should change { sites(:default).reload.posts_count }.by(-1)
  end
  
  it "decrements cached user posts_count" do
    @deleting_post.should change { users(:default).reload.posts_count }.by(-1)
  end

  it "fixes last_user_id" do
    topics(:default).last_user_id = 1; topics(:default).save
    posts(:default).destroy
    topics(:default).reload.last_user.should == users(:default)
  end
  
  it "fixes last_updated_at" do
    posts(:default).destroy
    topics(:default).reload.last_updated_at.should == posts(:second).created_at
  end
  
  it "fixes #last_post" do
    topics(:default).recent_post.should == posts(:default)
    posts(:default).destroy
    topics(:default).recent_post(true).should == posts(:second)
  end
end

describe Post, "being deleted as sole post in topic" do
  define_models
  
  it "clears topic" do
    posts(:default).destroy
    lambda { topics(:default).reload }.should raise_error(ActiveRecord::RecordNotFound)
  end
end

describe Post, "#editable_by?" do
  before do
    @user  = mock_model User
    @post  = Post.new :forum => @forum
    @forum = mock_model Forum, :user_id => @user.id
  end

  it "restricts user for other post" do
    @user.should_receive(:moderator_of?).and_return(false)
    @post.should_not be_editable_by(@user)
  end

  it "allows user" do
    @post.user_id = @user.id
    @user.should_receive(:moderator_of?).and_return(false)
    @post.should be_editable_by(@user)
  end
  
  it "allows admin" do
    @user.should_receive(:moderator_of?).and_return(true)
    @post.should be_editable_by(@user)
  end
  
  it "restricts moderator for other forum" do
    @post.should_receive(:forum).and_return @forum
    @user.should_receive(:moderator_of?).with(@forum).and_return(false)
    @post.should_not be_editable_by(@user)
  end
  
  it "allows moderator" do
    @post.should_receive(:forum).and_return @forum
    @user.should_receive(:moderator_of?).with(@forum).and_return(true)
    @post.should be_editable_by(@user)
  end
end
