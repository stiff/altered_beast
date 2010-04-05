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

  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "ADMINEMAIL"
      @subject     = "[YOURSITE] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
