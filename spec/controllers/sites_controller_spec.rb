require File.dirname(__FILE__) + '/../spec_helper'

describe SitesController, "GET #index" do
  define_models :sites_controller

  act! { get :index }

  before do
    @controller.stub!(:admin_required).and_return(true)
    @controller.stub!(:require_site)
  end

  it_assigns :sites
  it_renders :template, :index

  describe SitesController, "(xml)" do
    define_models :sites_controller

    act! { get :index, :format => 'xml' }

    it_assigns :sites
    it_renders :xml
  end
end

describe SitesController, "GET #show" do
  define_models :sites_controller

  act! { get :show, :id => @site.to_param }

  before do
    @site  = sites(:default)
    @controller.stub!(:admin_required).and_return(true)
    @controller.stub!(:require_site)
  end

  it_assigns :site
  it_renders :template, :show

  describe SitesController, "(xml)" do
    define_models :sites_controller

    act! { get :show, :id => @site.to_param, :format => 'xml' }

    it_renders :xml
  end
end

describe SitesController, "GET #new" do
  define_models :sites_controller
  act! { get :new }

  before do
    @controller.stub!(:admin_required).and_return(true)
    login_as :default
  end

  it "assigns @site" do
    act!
    assigns[:site].should be_new_record
  end

  it "assigns current host to new @site" do
    request.host = "my.host"
    act!
    assigns[:site].host.should == "my.host"
  end

  it_renders :template, :new

  describe SitesController, "(xml)" do
    define_models :sites_controller
    act! { get :new, :format => 'xml' }

    it_assigns :site
    it_renders :xml
  end
end

describe SitesController, "GET #edit" do
  define_models :sites_controller
  act! { get :edit, :id => @site.to_param }

  before do
    login_as :default
    @site  = sites(:default)
    @controller.stub!(:admin_required).and_return(true)
    @controller.stub!(:require_site)
  end

  it_assigns :site
  it_renders :template, :edit
end

describe SitesController, "POST #create" do
  before do
    login_as :default
    @attributes = {:name => 'yow'}
    @controller.stub!(:admin_required).and_return(true)
  end

  describe SitesController, "(successful creation)" do
    define_models :sites_controller
    act! { post :create, :site => @attributes }

    it_assigns :site, :flash => { :notice => :not_nil }
    it_redirects_to { site_path(assigns(:site)) }
  end

  describe SitesController, "(successful creation, xml)" do
    define_models :sites_controller
    act! { post :create, :site => @attributes, :format => 'xml' }

    it_assigns :site, :headers => { :Location => lambda { site_url(assigns(:site)) } }
    it_renders :xml, :status => :created
  end

  describe SitesController, "(unsuccessful creation)" do
    define_models :sites_controller
    act! { post :create, :site => {:name => ''} }

    it_assigns :site
    it_renders :template, :new
  end

  describe SitesController, "(unsuccessful creation, xml)" do
    define_models :sites_controller
    act! { post :create, :site => {:name => ''}, :format => 'xml' }

    it_assigns :site
    it_renders :xml, :status => :unprocessable_entity
  end
end

describe SitesController, "PUT #update" do
  before do
    login_as :default
    @site = sites(:default)
    @controller.stub!(:admin_required).and_return(true)
    @controller.stub!(:require_site)
  end

  describe SitesController, "(successful save)" do
    define_models :sites_controller
    act! { put :update, :id => @site.to_param, :site => {} }

    it_assigns :site, :flash => { :notice => :not_nil }
    it_redirects_to { site_path(@site) }
  end

  describe SitesController, "(successful save, xml)" do
    define_models :sites_controller
    act! { put :update, :id => @site.to_param, :site => {}, :format => 'xml' }

    it_assigns :site
    it_renders :blank
  end

  describe SitesController, "(unsuccessful save)" do
    define_models :sites_controller
    act! { put :update, :id => @site.to_param, :site => {:name => ''} }

    it_assigns :site
    it_renders :template, :edit
  end

  describe SitesController, "(unsuccessful save, xml)" do
    define_models :sites_controller
    act! { put :update, :id => @site.to_param, :site => {:name => ''}, :format => 'xml' }

    it_assigns :site
    it_renders :xml, :status => :unprocessable_entity
  end
end

describe SitesController, "DELETE #destroy" do
  define_models :sites_controller
  act! { delete :destroy, :id => @site.to_param }

  before do
    login_as :default
    @site = sites(:default)
    @controller.stub!(:admin_required).and_return(true)
    @controller.stub!(:require_site)
  end

  it_assigns :site
  it_redirects_to { sites_path }

  describe SitesController, "(xml)" do
    define_models :sites_controller
    act! { delete :destroy, :id => @site.to_param, :format => 'xml' }

    it_assigns :site
    it_renders :blank
  end
end