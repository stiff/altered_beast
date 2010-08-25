require File.dirname(__FILE__) + '/../../spec_helper'

describe "/topics/show.html.erb" do
  define_models :topics_controller
  
  def head_content
    response.template.instance_variable_get("@content_for_head_content")
  end
  
  before do
    @topic  = topics(:default)

    @user = users(:default)
    @user.signature = "A very provocative signature"
    @user.signature_html = "A very provocative signature"

    @post = posts(:default)
    @post.body_html = "A very insightful comment"
    @post.user = @user
    
    @posts = [@post].paginate :page => 1

    @topic.title = "Topic Title"
    @topic.tags = [Tag.new(:name => "first tag"), Tag.new(:name => "other tag")]

    assigns[:topic] = @topic
    assigns[:posts] = @posts
  end

  it "should render topic's title as meta description" do
  	render "/topics/show.html.erb"
  	head_content.should include('<meta content="Topic title" name="description" />')
  end
  
  it "should render topic's tags as meta description" do
  	render "/topics/show.html.erb"
  	head_content.should include('<meta content="first tag, other tag" name="keywords" />')
  end
  
  it "should include user's signature in posts" do
    render "/topics/show.html.erb"
    response.should have_tag("div[class=?]", "signature")
    response.body.should include("A very provocative signature")
  end
end

