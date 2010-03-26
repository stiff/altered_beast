#require File.dirname(__FILE__) + '/../spec_helper'
#
#describe ForumsController, "GET #index" do
#  define_models
#
#  act! { get :index }
#
#  before do
#    login_as :default
#    current_site :default
#    @controller.stub!(:admin_required).and_return(true)
#    session[:forums_page] = {1 => 5}
#    @forum_time = session[:forums] = {1 => 5.minutes.ago.utc}
#  end
#
#  it_assigns :forums, :session => {:forums_page => nil, :forums => lambda { @forum_time }}
#  it_renders :template, :index
#
#  describe ForumsController, "(xml)" do
#    define_models
#
#    act! { get :index, :format => 'xml' }
#
#    it_assigns :forums
#    it_renders :xml
#  end
#end
#
#describe ForumsController, "GET #show" do
#  define_models
#
#  act! { get :show, :id => @forum.to_param }
#
#  before do
#    current_site :default
#    @forum  = forums(:default)
#    @forum_page = session[:forums_page] = {@forum.id => 1}
#    @forum_time = session[:forums]      = {@forum.id => Time.utc(2007, 1, 1)}
#  end
#
#  it_assigns :topics, :forum, :session => {:forums_page => lambda { @forum_page }, :forums => lambda { @forum_time }}
#  it_renders :template, :show
#
#  it "sets session[:forums] if logged in" do
#    login_as :default
#    act!
#    session[:forums][@forum.id].should == current_time
#  end
#
#  describe ForumsController, "(paged)" do
#    define_models
#    act! { get :show, :id => @forum.to_param, :page => 5 }
#
#    it_assigns :session => { :forums_page => lambda { {@forum.id => 5} } }
#  end
#
#  describe ForumsController, "(xml)" do
#    define_models
#
#    act! { get :show, :id => @forum.to_param, :format => 'xml' }
#
#    it_assigns :topics => :undefined
#    it_renders :xml
#  end
#end
#
#describe ForumsController, "GET #new" do
#  define_models
#  act! { get :new }
#  before do
#    login_as :default
#    current_site :default
#    @controller.stub!(:admin_required).and_return(true)
#  end
#
#  it "assigns @forum" do
#    act!
#    assigns[:forum].should be_new_record
#  end
#
#  it_renders :template, :new
#
#  describe ForumsController, "(xml)" do
#    define_models
#    act! { get :new, :format => 'xml' }
#
#    it_renders :xml
#  end
#end
#
#describe ForumsController, "GET #edit" do
#  define_models
#  act! { get :edit, :id => @forum.to_param }
#
#  before do
#    login_as :default
#    current_site :default
#    @forum  = forums(:default)
#    @controller.stub!(:admin_required).and_return(true)
#  end
#
#  it_assigns :forum
#  it_renders :template, :edit
#end
#
#describe ForumsController, "POST #create" do
#  before do
#    @attributes = {'name' => "Default"}
#    current_site :default
#    login_as :default
#    @controller.stub!(:admin_required).and_return(true)
#  end
#
#  describe ForumsController, "(successful creation)" do
#    define_models
#    act! { post :create, :forum => @attributes }
#
#    it_assigns :forum, :flash => { :notice => :not_nil }
#    it_redirects_to { forum_path(assigns(:forum)) }
#  end
#
#  describe ForumsController, "(successful creation, xml)" do
#    define_models
#    act! { post :create, :forum => @attributes, :format => 'xml' }
#
#    it_assigns :forum, :headers => { :Location => lambda { forum_url(assigns(:forum)) } }
#    it_renders :xml, :status => :created
#  end
#
#  describe ForumsController, "(unsuccessful creation)" do
#    define_models
#    act! { post :create, :forum => {:name => ''} }
#
#    it_assigns :forum
#    it_renders :template, :new
#  end
#
#  describe ForumsController, "(unsuccessful creation, xml)" do
#    define_models
#    act! { post :create, :forum => {:name => ''}, :format => 'xml' }
#
#    it_assigns :forum
#    it_renders :xml, :status => :unprocessable_entity
#  end
#end
#
#describe ForumsController, "PUT #update" do
#  before do
#    login_as :default
#    current_site :default
#    @attributes = {'name' => "Default"}
#    @forum      = forums(:default)
#    @controller.stub!(:admin_required).and_return(true)
#  end
#
#  describe ForumsController, "(successful save)" do
#    define_models
#    act! { put :update, :id => @forum.to_param, :forum => @attributes }
#
#    it_assigns :forum, :flash => { :notice => :not_nil }
#    it_redirects_to { forum_path(@forum) }
#  end
#
#  describe ForumsController, "(successful save, xml)" do
#    define_models
#    act! { put :update, :id => @forum.to_param, :forum => @attributes, :format => 'xml' }
#
#    it_assigns :forum
#    it_renders :blank
#  end
#
#  describe ForumsController, "(unsuccessful save)" do
#    define_models
#    act! { put :update, :id => @forum.to_param, :forum => {:name => ''} }
#
#    it_assigns :forum
#    it_renders :template, :edit
#  end
#
#  describe ForumsController, "(unsuccessful save, xml)" do
#    define_models
#    act! { put :update, :id => @forum.to_param, :forum => {:name => ''}, :format => 'xml' }
#
#    it_assigns :forum
#    it_renders :xml, :status => :unprocessable_entity
#  end
#end
#
#describe ForumsController, "DELETE #destroy" do
#  define_models
#  act! { delete :destroy, :id => @forum.to_param }
#
#  before do
#    login_as :default
#    current_site :default
#    @forum      = forums(:default)
#    @controller.stub!(:admin_required).and_return(true)
#  end
#
#  it_assigns :forum
#  it_redirects_to { forums_path }
#
#  describe ForumsController, "(xml)" do
#    define_models
#    act! { delete :destroy, :id => @forum.to_param, :format => 'xml' }
#
#    it_assigns :forum
#    it_renders :blank
#  end
#end