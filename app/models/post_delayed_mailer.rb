class PostDelayedMailer < Struct.new(:user, :post)

  def perform
    UserMailer.deliver_topic_updated(user, post)
  end
  
end