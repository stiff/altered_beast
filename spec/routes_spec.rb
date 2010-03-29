require File.dirname(__FILE__) + '/spec_helper'
include Spec::Rails::Example::RoutingHelpers

describe "Routes" do

  it "root should open forum's topic list" do
    params_from(:get, "/")[:action].should == "show"
    params_from(:get, "/")[:controller].should == "forums"
    params_from(:get, "/")[:id].should == "arquitetura"
  end

  it "topics should be in /topics/topic-name" do
    params_from(:get, "/topics/topic-name")[:action].should == "show"
    params_from(:get, "/topics/topic-name")[:controller].should == "topics"
    params_from(:get, "/topics/topic-name")[:id].should == "topic-name"
  end

end