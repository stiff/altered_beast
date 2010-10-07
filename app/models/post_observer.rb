class PostObserver < ActiveRecord::Observer
  observe :post
  
  def after_save(post)
    unless post.was_modified?
      post.topic.monitoring_users.each do |user|  
        Delayed::Job.enqueue( PostDelayedMailer.new(user, post) ) unless user.is_owner_of?(post)
      end 
    end
  end
end
