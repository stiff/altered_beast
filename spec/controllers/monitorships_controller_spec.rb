require File.dirname(__FILE__) + '/../spec_helper'

describe MonitorshipsController, "PUT #update" do
  define_models

  before do
    login_as :default
    @topic = mock_model(Topic)
    @monitorship = mock_model(Monitorship)
    Topic.stub!(:find_by_permalink).with("topic-name").and_return(@topic)
    Monitorship.stub!(:find_or_initialize_by_user_id_and_topic_id).and_return(@monitorship)
  end

  it "should enable monitorship for a post, for a user" do
    @monitorship.should_receive(:update_attribute).with(:active, true)
    put :update, :id => 'topic-name', :enable_monitor => 'on'
  end

  it "should disable monitorship for a post, for a user" do
    @monitorship.should_receive(:update_attribute).with(:active, false)
    put :update, :id => 'topic-name'
  end

end
