module PathHelper

  def forum_posts_path(forum, data = {})
    post_path(data)
  end

  def new_forum_topic_path(forum)
    new_topic_path
  end

  def forum_topic_path(forum, topic, data = {})
    topic_path(topic, data)
  end

  def forum_path(forum)
    root_path
  end

  def formatted_forum_topic_posts_path(forum, topic, format)
    formatted_topic_posts_path(forum, topic, {})
  end

  def forum_topic_posts_path(forum, topic, data = {})
    topic_posts_path(topic, data)
  end

  def forum_topics_path(forum)
    topics_path
  end

  def edit_forum_topic_path(forum, topic)
    edit_topic_path(topic)
  end

  def edit_forum_topic_post_path(forum, topic, post, data = {})
    edit_topic_post_path(topic, post, data)
  end

  def forum_topic_post_path(forum, topic, post, data = {})
    topic_post_path(topic, post, data)
  end

end