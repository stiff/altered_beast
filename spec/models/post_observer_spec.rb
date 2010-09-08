require File.dirname(__FILE__) + '/../spec_helper'

describe PostObserver do
  define_models
  it "should give an instance of" do
    post = posts :default
    owner = users :default
    admin = users :admin

    topic = post.topic
    monitor_1 = Monitorship.new :user_id=>owner.id, :topic_id=>topic.id
    monitor_2 = Monitorship.new :user_id=>admin.id, :topic_id=>topic.id
    topic.monitorships << [monitor_1, monitor_2]


    topic.should_receive(:monitoring_users).and_return([owner, admin])
    admin.should_receive(:is_owner_of?).with(post).and_return(false)
    UserMailer.should_receive(:deliver_topic_updated).with(admin, post)
    UserMailer.should_not_receive(:deliver_topic_updated).with(owner, post)

    obs = PostObserver.instance    
    obs.after_save post
  end
end
