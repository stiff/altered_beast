module TopicsHelper
  def monitoring?
    logged_in? && !Monitorship.count(:id, :conditions => ["user_id = ? and topic_id = ? and active = ?", current_user.id, @topic.id, true]).zero?
  end

  def page
    session[:forum_page] ? session[:forum_page][@topic.forum.id] : nil
  end
  
  def time_ago_formatted(time_ago)
    time_ago_in_words(time_ago).gsub("aproximadamente ", "").capitalize
  end
end
