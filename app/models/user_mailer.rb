class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += I18n.t 'txt.subject_activate', :default => 'Please activate your new account'
    @body[:url]  = activate_url(user.activation_code, :host => user.site.host)
  end

  def activation(user)
    setup_email(user)
    @subject    += I18n.t 'txt.subject_activated', :default => 'Your account has been activated!'
    @body[:url]  = root_url(:host => user.site.host)
  end

  def topic_updated(user, post)
    setup_email(user)
    @subject    += "#{I18n.t 'txt.topic', :default => 'Topic'} #{post.topic.title} #{I18n.t 'txt.updated', :default => 'updated'}"
    @body[:url]  = root_url(:host => user.site.host)
    @body[:message]  = post.body[0..100]
    @body[:message]  += "..." if post.body.size > 100
    @body[:url]  = topic_url(post.topic, :host => user.site.host)
  end

  def remember_password(user)
    setup_email(user)
    @subject    += "#{I18n.t 'txt.request_to_change_your_password', :default => 'Request to change your password'}"
    @body[:url]  = reset_password_url(:secret => user.lost_password_secret, :host => user.site.host)
  end
  
  def hottest_topics(email, topics)
    @recipients  = email
    @from        = "no-reply@tectura.com.br"
    @subject     = "[tectura.com.br] - hottest topics"
    @sent_on     = Time.now
    @body[:self] = self
    @body[:users] = User.find_all_by_receive_mailing(true).map { |u| u.email }
    @body[:topics] = topics
    
  end

  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "no-reply@tectura.com.br"
      @subject     = "[tectura.com.br] - "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
