require File.dirname(__FILE__) + '/../../spec_helper'

describe "/topics/show.html.erb" do
  define_models :topics_controller
  
  before do
    @forum  = forums(:default)
    @topic  = topics(:default)
    Forum.stub!(:first).and_return(@forum)

    @topic.title = "Topic Title"

    assigns[:topic] = @topic
    assigns[:posts] = []
  end

  it "should render post title as meta description" do
  	render "/topics/show.html.erb"
  	response.template.instance_variable_get("@content_for_head_content").should include('<meta content="Topic title" name="description" />')
  end
end

