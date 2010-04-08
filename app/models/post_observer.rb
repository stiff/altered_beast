class PostObserver < ActiveRecord::Observer
  observe :post
  
  def after_save(post)
    post.topic.monitoring_users.each do |user|
      UserMailer.deliver_topic_updated(user, post)
    end
  end
end