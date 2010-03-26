require File.dirname(__FILE__) + '/../spec_helper'

describe ForumsController, "(remember-me functionality)" do
  define_models

  before do
    session[:forums_page] = {}
    session[:user_id] = {}
  end

  it "logs in with valid login token" do
    pending
    @request.cookies['auth_token'] = CGI::Cookie.new('auth_token', users(:activated).remember_token)

    get :index

    controller.send(:current_user).should == users(:activated)
  end
end
