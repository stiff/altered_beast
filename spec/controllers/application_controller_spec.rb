require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationController, "Spambot Filter" do
  include PathHelper
    
  def should_redirect_requests_with_non_empty_spamcheck_field
    controller.should_receive(:redirect_to).with(root_url)
    controller.params[:extra] = "not empty"
    controller.send(:spambot_filter)
  end
  
  def should_not_redirect_requests_with_empty_spamcheck_field
    controller.should_receive(:redirect_to).never
    controller.params[:extra] = ""
    controller.send(:spambot_filter)
  end
  
end