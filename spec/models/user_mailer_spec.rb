require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserMailer do
  
  class UserMailer
    def post_path(post, host)
      return "url to post"
    end
  end
  
  it "should mail post url" do
    site = mock(Site)
    site.stub!(:host).and_return("tectura.com.br")
    
    user = mock(User)
    user.stub!(:email).and_return("user@provider.com")
    user.stub!(:site).and_return(site)
    
    topic = mock(Topic)
    topic.stub!(:title).and_return("Amazing topic")
    
    post = mock(Post)
    post.stub!(:topic).and_return(topic)
    post.stub!(:body).and_return("Very insightful post body.")
    
    mail = UserMailer.deliver_topic_updated(user, post)
    
    mail.to_s.index("url to post").should_not be_nil
  end

end
