# coding: utf-8
class UserMailer < ActionMailer::Base
  default :from => "your_domain@example.com"

  def signup_notification(user)
    @user = user
    @url = activate_url(user.activation_code, :host => user.site.host)
    mail :to => user.email, :subject => subject(user, "Please activate your new account")
  end

  def activation(user)
    @user = user
    @url = root_url(:host => user.site.host)
    mail :to => user.email, :subject => subject(user, "Your account has been activated!")
  end

  protected

    def subject(user, text)
      [user.site.name, text] * " – "
    end
end
