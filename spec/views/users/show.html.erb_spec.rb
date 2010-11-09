require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/show.html.erb" do
  define_models :users_controller
  
  before do
    @user = users(:default)
    @user.signature = "A very provocative signature"
    @user.signature_html = "A very provocative signature"
    
    @admin = mock_model(User)
    @admin.stub!('admin?').and_return(true)
    
    assigns[:user] = @user
  end

  it "should show user email to admins" do
    template.should_receive(:current_user).twice().and_return(@admin)
    render "/users/show.html.erb"
    response.body.should include("normal-user")
    response.body.should include("normal-user@example.com")
  end
  
  it "should not show user email to non-admins" do
    template.should_receive(:current_user).twice().and_return(@user)
    render "/users/show.html.erb"
    response.body.should include("normal-user")
    response.body.should_not include("normal-user@example.com")
  end
end

