require File.dirname(__FILE__) + '/../spec_helper'

module PostsControllerParentObjects
  def self.included(base)
    base.define_models

    base.before do
      login_as :default
      @user  = users(:default)
      @post  = posts(:default)
      @forum = forums(:default)
      @topic = topics(:default)
      Forum.stub!(:first).and_return(@forum)
    end
  end
end

describe PostsController, "GET #index" do
  include PostsControllerParentObjects
  include PathHelper

  act! { get :index, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :user => nil, :q => 'foo', :page => 5 }

  it_assigns :posts, :forum, :topic, :parent => lambda { @topic }
  it_renders :template, :index

  describe PostsController, "(xml)" do
    define_models

    act! { get :index, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :user => nil, :q => 'foo', :page => 5, :format => 'xml' }

    it_assigns :posts, :forum, :topic, :parent => lambda { @topic }
    it_renders :xml
  end

  describe PostsController, "(atom)" do
    define_models

    act! { get :index, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :user => nil, :q => 'foo', :page => 5, :format => 'atom' }

    it_assigns :posts, :forum, :topic, :parent => lambda { @topic }
    it_renders :template, :index, :format => :atom
  end
end

describe PostsController, "GET #index (for forums)" do
  include PostsControllerParentObjects
  include PathHelper

  act! { get :index, :forum_id => @forum.to_param, :page => 5, :q => 'foo' }

  it_assigns :posts, :forum, :topic => nil, :user => nil, :parent => lambda { @forum }
  it_renders :template, :index

  describe PostsController, "(atom)" do
    define_models

    act! { get :index, :forum_id => @forum.to_param, :page => 5, :q => 'foo', :format => 'atom' }

    it_assigns :posts, :forum, :topic => nil, :user => nil, :parent => lambda { @forum }
    it_renders :template, :index, :format => "atom"
  end

  describe PostsController, "(xml)" do
    define_models

    act! { get :index, :forum_id => @forum.to_param, :page => 5, :q => 'foo', :format => 'xml' }

    it_assigns :posts, :forum, :topic => nil, :user => nil, :parent => lambda { @forum }
    it_renders :xml
  end
end

describe PostsController, "GET #index (for users)" do
  include PostsControllerParentObjects
  include PathHelper

  act! { get :index, :user_id => @user.to_param, :q => 'foo', :page => 5 }

  it_assigns :posts, :user, :forum => nil, :topic => nil, :parent => lambda { @user }
  it_renders :template, :index

  describe PostsController, "(xml)" do
    define_models

    act! { get :index, :user_id => @user.to_param, :page => 5, :q => 'foo', :format => 'xml' }

    it_assigns :posts, :user, :forum => nil, :topic => nil, :parent => lambda { @user }
    it_renders :xml
  end
end

describe PostsController, "GET #index (globally)" do
  include PostsControllerParentObjects
  include PathHelper

  act! { get :index, :page => 5, :q => 'foo' }

  it_assigns :posts, :user => nil, :forum => nil, :topic => nil, :parent => nil
  it_renders :template, :index

  describe PostsController, "(xml)" do
    define_models

    act! { get :index, :page => 5, :q => 'foo', :format => 'xml' }

    it_assigns :posts, :user => nil, :forum => nil, :topic => nil, :parent => nil
    it_renders :xml
  end

  describe PostsController, "(atom)" do
    define_models

    act! { get :index, :page => 5, :q => 'foo', :format => 'atom' }

    it_assigns :posts, :user => nil, :forum => nil, :topic => nil, :parent => nil
    it_renders :template, :index, :format => 'atom'
  end
end

describe PostsController, "GET #show" do
  include PostsControllerParentObjects
  include PathHelper
  define_models

  act! { get :show, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param }

  it_assigns :forum, :topic, :parent => lambda { @topic }, :post => nil
  it_redirects_to { forum_topic_path(@forum, @topic) }

  describe PostsController, "(xml)" do
    define_models

    it_assigns :post, :forum, :topic, :parent => lambda { @topic }

    act! { get :show, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param, :format => 'xml' }

    it_renders :xml, :post
  end
end

describe PostsController, "GET #edit" do
  include PostsControllerParentObjects
  include PathHelper

  act! { get :edit, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param }

  it_assigns :post, :forum, :topic, :parent => lambda { @topic }
  it_renders :template, :edit
end

describe PostsController, "POST #create" do
  include PostsControllerParentObjects
  include PathHelper

  before do
    @post = nil
  end

  describe PostsController, "(successful creation)" do
    define_models
    act! { post :create, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :post => {:body => 'foo'} }

    it_assigns :post, :forum, :topic, :parent => lambda { @topic }, :flash => { :notice => :not_nil }
    it_redirects_to { forum_topic_post_path(@forum, @topic, assigns(:post), :anchor => "post_#{assigns(:post).id}") }
  end

  describe PostsController, "(unsuccessful creation)" do
    define_models
    act! { post :create, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :post => {:body => ''} }

    it_assigns :post, :forum, :topic, :parent => lambda { @topic }
    it_redirects_to { forum_topic_url(@forum, @topic) }
  end

  describe PostsController, "(successful creation, xml)" do
    define_models
    act! { post :create, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :post => {:body => 'foo'}, :format => 'xml' }

    it_assigns :post, :forum, :topic, :parent => lambda { @topic }, :headers => { :Location => lambda { forum_topic_post_url(@forum, @topic, assigns(:post)) } }
    it_renders :xml, :status => :created
  end

  describe PostsController, "(unsuccessful creation, xml)" do
    define_models
    act! { post :create, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :post => {:body => ''}, :format => 'xml' }

    it_assigns :post, :forum, :topic, :parent => lambda { @topic }
    it_renders :xml, :status => :unprocessable_entity
  end
end

describe PostsController, "PUT #update" do
  include PostsControllerParentObjects
  include PathHelper

  describe PostsController, "(successful save)" do
    define_models
    act! { put :update, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param, :post => {} }

    it_assigns :post, :forum, :topic, :parent => lambda { @topic }, :flash => { :notice => :not_nil }
    it_redirects_to { forum_topic_path(@forum, @topic, :anchor => "post_#{@post.id}") }
  end

  describe PostsController, "(unsuccessful save)" do
    define_models
    act! { put :update, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param, :post => {:body => ''} }

    it_assigns :post, :forum, :topic, :parent => lambda { @topic }
    it_renders :template, :edit
  end

  describe PostsController, "(successful save, xml)" do
    define_models
    act! { put :update, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param, :post => {}, :format => 'xml' }

    it_assigns :post, :forum, :topic
    it_renders :blank
  end

  describe PostsController, "(unsuccessful save, xml)" do
    define_models
    act! { put :update, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param, :post => {:body => ''}, :format => 'xml' }

    it_assigns :post, :forum, :topic, :parent => lambda { @topic }
    it_renders :xml, :status => :unprocessable_entity
  end
end

describe PostsController, "DELETE #destroy" do
  include PostsControllerParentObjects
  include PathHelper

  act! { delete :destroy, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param }

  it_assigns :post, :forum, :topic, :parent => lambda { @topic }
  it_redirects_to { forum_topic_path(@forum, @topic) }

  describe PostsController, "(xml)" do
    define_models
    act! { delete :destroy, :forum_id => @forum.to_param, :topic_id => @topic.to_param, :id => @post.to_param, :format => 'xml' }

    it_assigns :post
    it_renders :blank
  end
end
