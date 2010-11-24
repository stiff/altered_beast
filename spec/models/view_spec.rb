require File.dirname(__FILE__) + '/../spec_helper'

describe Topic, "Hits count" do
  define_models
  before do
    sleep 1
    @initTime = 2.days.ago
    
    @topic1 = topics(:default)
    @topic2 = topics(:other)
    @topic3 = topics(:other_forum)
    
    @topic1.hit! #1 hit
    10.times do |n|
      @topic3.hit! #10 hits
      @topic2.hit! 
    end
    @topic2.hit! # 11 hots
  end
  
  it "top hottest topics" do
    hottest_topics = Topic.top_hottest_since(@initTime, 2)
    
    hottest_topics.size.should == 2
    hottest_topics.should include(@topic2)
    hottest_topics.should include(@topic3)
  end
  
  it "should produce a new view for every hit on a topic" do
    views = View.all.size
    @topic1.hit!
    View.all.size.should == views+1
  end
  
  it "should send an email with the latest hottest topics" do
    hottest_topics = mock(Array)
    shy_users = mock(Array)
    Topic.stub!(:top_hottest_since).with(15.days.ago).and_return(hottest_topics)
    User.stub!(:recent_and_silent).and_return(shy_users)
    UserMailer.should_receive(:deliver_hottest_topics).with(anything(), hottest_topics, shy_users)
    Topic.send_hottest_topics_to_gui()
  end
end
