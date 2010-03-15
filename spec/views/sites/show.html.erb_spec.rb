require File.dirname(__FILE__) + '/../../spec_helper'

describe "/sites/show.html.erb" do
  define_models :sites_controller
  include SitesHelper
  
  before do
    @site = sites(:other)

    assigns[:site] = @site
  end

  it "should render attributes in <p>" do
  	pending
  end
end

