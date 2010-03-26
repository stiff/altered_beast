require File.dirname(__FILE__) + '/../spec_helper'

describe TopicsController, "GET #index" do
  define_models
  include PathHelper

  act! { get :index, :forum_id => @forum.to_param }

  before do
    @forum  = forums(:default)
  end

  it_assigns :forum, :topics => nil
  it_redirects_to { forum_path(@forum) }

  describe TopicsController, "(xml)" do
    define_models

    act! { get :index, :forum_id => @forum.to_param, :page => 5, :format => 'xml' }

    it_assigns :topics, :forum
    it_renders :xml
  end
end

describe TopicsController, "GET #show" do
  define_models
  include PathHelper

  act! { get :show, :forum_id => @forum.to_param, :id => @topic.to_param, :page => 5 }

  before do
    @forum  = forums(:default)
    @topic  = topics(:default)
  end

  it_assigns :topic, :forum, :posts, :session => {:topics => nil}
  it_renders :template, :show

  it "should render atom feed" do
    pending "no atom support yet"
  end

  it "increments topic hit count" do
    stub_topic!
    @topic.should_receive(:hit!)
    act!
  end

  it "assigns new post record" do
    act!
    assigns[:post].should be_new_record
  end

  describe TopicsController, "(logged in)" do
    define_models
    include PathHelper

    act! { get :show, :forum_id => @forum.to_param, :id => @topic.to_param, :page => 5 }

    before do
      login_as :default
    end

    it_assigns :topic, :forum, :session => {:topics => :not_nil}

    it "increments topic hit count" do
      stub_topic!
      @topic.user_id = 5
      @topic.should_receive(:hit!)
      act!
    end

    it "doesn't increment topic hit count for same user" do
      stub_topic!
      @topic.stub!(:hit!).and_return { raise "Noooooo" }
      act!
    end

    it "marks User#last_seen_at" do
      @controller.stub!(:current_user).and_return(@user)
      @user.should_receive(:seen!)
      act!
    end
  end

  describe TopicsController, "(xml)" do
    define_models
    include PathHelper

    act! { get :show, :forum_id => @forum.to_param, :id => @topic.to_param, :format => 'xml' }

    it_assigns :topic, :post => nil, :posts => nil

    it_renders :xml, :topic
  end

protected
  def stub_topic!
    Forum.stub!(:first).and_return(@forum)
    @forum.stub!(:topics).and_return([])
    @forum.topics.stub!(:find_by_permalink).with(@topic.to_param).and_return(@topic)
  end
end

describe TopicsController, "GET #new" do
  define_models
  include PathHelper

  act! { get :new, :forum_id => @forum.to_param }
  before do
    login_as :default
    @forum  = forums(:default)
  end

  it_assigns :forum, :topic

  it "assigns @topic" do
    act!
    assigns[:topic].should be_new_record
  end

  it_renders :template, :new

  describe TopicsController, "(xml)" do
    define_models
    include PathHelper

    act! { get :new, :forum_id => @forum.to_param, :format => 'xml' }

    it_assigns :forum, :topic

    it_renders :xml
  end
end

describe TopicsController, "GET #edit" do
  define_models
  include PathHelper

  act! { get :edit, :forum_id => @forum.to_param, :id => @topic.to_param }

  before do
    login_as :default
    @forum  = forums(:default)
    @topic  = topics(:default)
  end

  it_assigns :topic, :forum
  it_renders :template, :edit
end

describe TopicsController, "POST #create" do
  include PathHelper

  before do
    login_as :default
    @forum  = forums(:default)
  end

  describe TopicsController, "(successful creation)" do
    define_models
    include PathHelper

    act! { post :create, :forum_id => @forum.to_param, :topic => {:title => 'foo', :body => 'bar'} }

    it_assigns :forum, :topic, :flash => { :notice => :not_nil }
    it_redirects_to { forum_topic_path(@forum, assigns(:topic)) }
  end

  describe TopicsController, "(unsuccessful creation)" do
    define_models
    include PathHelper

    act! { post :create, :forum_id => @forum.to_param, :topic => @attributes }

    before do
      @attributes = {:title => ''}
    end

    it_assigns :forum, :topic
    it_renders :template, :new
  end

  describe TopicsController, "(successful creation, xml)" do
    define_models
    include PathHelper

    act! { post :create, :forum_id => @forum.to_param, :topic => {:title => 'foo', :body => 'bar'}, :format => 'xml' }

    it_assigns :forum, :topic, :headers => { :Location => lambda { forum_topic_url(@forum, assigns(:topic)) } }
    it_renders :xml, :status => :created
  end

  describe TopicsController, "(unsuccessful creation, xml)" do
    define_models
    include PathHelper

    act! { post :create, :forum_id => @forum.to_param, :topic => {}, :format => 'xml' }

    it_assigns :forum, :topic
    it_renders :xml, :status => :unprocessable_entity
  end
end

describe TopicsController, "PUT #update" do
  include PathHelper

  before do
    login_as :default
    @forum = forums(:default)
    @topic = topics(:default)
  end

  describe TopicsController, "(successful save)" do
    define_models
    include PathHelper

    act! { put :update, :forum_id => @forum.to_param, :id => @topic.to_param, :topic => {} }

    it_assigns :forum, :topic, :flash => { :notice => :not_nil }
    it_redirects_to { forum_topic_path(@forum, @topic) }
  end

  describe TopicsController, "(unsuccessful save)" do
    define_models
    include PathHelper

    act! { put :update, :forum_id => @forum.to_param, :id => @topic.to_param, :topic => @attributes }

    before do
      @attributes = {:title => ''}
      @topic.update_attributes @attributes
    end

    it_assigns :topic, :forum
    it_renders :template, :edit
  end

  describe TopicsController, "(successful save, xml)" do
    define_models
    include PathHelper

    act! { put :update, :forum_id => @forum.to_param, :id => @topic.to_param, :topic => {}, :format => 'xml' }

    it_assigns :topic, :forum
    it_renders :blank
  end

  describe TopicsController, "(unsuccessful save, xml)" do
    define_models
    include PathHelper

    act! { put :update, :forum_id => @forum.to_param, :id => @topic.to_param, :topic => @attributes, :format => 'xml' }

    before do
      @attributes = {:title => ''}
      @topic.update_attributes @attributes
    end

    it_assigns :topic, :forum
    it_renders :xml, "topic.errors", :status => :unprocessable_entity
  end
end

describe TopicsController, "DELETE #destroy" do
  define_models
  include PathHelper

  act! { delete :destroy, :forum_id => @forum.to_param, :id => @topic.to_param }

  before do
    login_as :default
    @forum = forums(:default)
    @topic = topics(:default)
  end

  it_assigns :topic, :forum
  it_redirects_to { forum_path(@forum) }

  describe TopicsController, "(xml)" do
    define_models
    include PathHelper

    act! { delete :destroy, :forum_id => @forum.to_param, :id => @topic.to_param, :format => 'xml' }

    it_assigns :topic, :forum
    it_renders :blank
  end
end
