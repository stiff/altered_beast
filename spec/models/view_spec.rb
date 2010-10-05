require File.dirname(__FILE__) + '/../spec_helper'

describe Topic, "Hits count" do
  define_models
  before do
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
    hottest_topics = Topic.top_hottest_since(2.days.ago, 2)
    
    hottest_topics.size.should == 2
    hottest_topics.first.should == @topic2
    hottest_topics.last.should == @topic3
  end
end
