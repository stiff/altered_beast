require File.dirname(__FILE__) + '/../spec_helper'

describe Site do
  define_models do
    model Site do
      stub :other, :name => 'other', :host => 'other.test.host'
    end
  end
  
  it "requires name" do
    site = new_site(:default, :name => nil, :host => 'foo.bar')
    site.should_not be_valid
    site.errors.on(:name).should_not be_nil
  end
  
  it "allows blank host" do
    Site.delete_all
    site = new_site(:default, :host => '', :name => 'foo.bar')
    site.should be_valid
  end
  
  it "validates uniqueness of host" do
    site = new_site(:default, :host => sites(:other).host, :name => 'foo.bar')
    site.should_not be_valid
    site.errors.on(:host).should_not be_nil
  end
  
  it "validates uniqueness of blank host" do
    site = new_site(:default, :host => '', :name => 'foo.bar')
    site.should_not be_valid
    site.errors.on(:host).should_not be_nil
  end
  
  it "downcases set host" do
    s = Site.new
    s.host = 'A'
    s.host.should == 'a'
  end
  
  it "accepts nil host value" do
    s = Site.new
    s.host = nil
    s.host.should == ''
  end
end

describe Site, "#find_by_host" do
  define_models do
    model Site do
      stub :other, :name => 'other', :host => 'other.test.host'
    end
  end
  
  it "finds site by host name" do
    Site.find_by_host(sites(:other).host).should == sites(:other)
  end
  
  it "strips host name" do
    Site.find_by_host("    " + sites(:other).host + "  ").should == sites(:other)
  end
  
  it "downcases host name" do
    Site.find_by_host("    " + sites(:other).host.upcase + "  ").should == sites(:other)
  end
  
  it "ignores 'www.' prefix" do
    Site.find_by_host("www." + sites(:other).host + "  ").should == sites(:other)
  end
  
  it "defaults to main site for no match" do
    Site.find_by_host(sites(:other).host + "www.").should == sites(:default)
  end
  
  it "finds main site" do
    Site.main.should == sites(:default)
    Site.find_by_host('').should == sites(:default)
  end
end

describe Site, "#users" do
  define_models do
    model Site do
      stub :other, :name => 'other', :host => 'other.test.host'
    end
    
    model User do
      stub :other, :signature => 'Programmer', :signature_html => '<p>Programmer</p>', :site => all_stubs(:other_site)
    end
  end
  
  it "finds only active users in the correct site" do
    sites(:default).users.sort_by(&:login).should == [users(:activated), users(:admin), users(:default)]
    sites(:other).users.should   == [users(:other)]
  end
  
  it "finds all users" do
    sites(:default).all_users.size.should == User.count-1
    sites(:default).all_users.should_not include(users(:other))
    
    sites(:other).all_users.should == [users(:other)]
  end
end
